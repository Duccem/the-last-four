class_name SlimeHurtState
extends EnemyState

@export var recovery_fallback: float = 0.5
@export var hurt_sound: AudioStream

@onready var idle: EnemyState = $"../idle_state"
@onready var walk: EnemyState = $"../walk_state"
@onready var wander: EnemyState = $"../wander_state"
@onready var death: EnemyState = $"../death_state"

var _next_state: EnemyState
var _animation_finished: bool = false
var _timer: float = 0.0


func enter() -> void:
	enemy.anim_state.travel("hurt")
	enemy.animation_controller.set_animation_direction(enemy.direction)
	enemy.audio.stream = hurt_sound
	enemy.audio.pitch_scale = randf_range(0.9, 1.1)
	enemy.audio.play()
	enemy.receive_damage(1)
	_next_state = _pick_next_state()
	_animation_finished = false
	_timer = recovery_fallback
	enemy.velocity = Vector2.ZERO
	if not enemy.anim_player.animation_finished.is_connected(_on_animation_finished):
		enemy.anim_player.animation_finished.connect(_on_animation_finished)
	


func process(delta: float) -> EnemyState:
	enemy.velocity = Vector2.ZERO
	_timer -= delta
	if _animation_finished or _timer <= 0.0:
		return _next_state

	var knockback_dir := -enemy.direction
	if knockback_dir != Vector2.ZERO:
		var knockback_factor := clampf(_timer / recovery_fallback, 0.0, 1.0)
		var knockback_speed := 150.0
		enemy.velocity = knockback_dir.normalized() * knockback_speed * knockback_factor

	return null


func exit() -> void:
	if enemy.anim_player.animation_finished.is_connected(_on_animation_finished):
		enemy.anim_player.animation_finished.disconnect(_on_animation_finished)
	_animation_finished = false
	
func _pick_next_state() -> EnemyState:
	if enemy.health_points <= 0:
		return death
	if walk != null and walk.on_range:
		return walk
	if wander != null:
		return wander
	return idle


func _on_animation_finished(_anim_name: StringName) -> void:
	_animation_finished = true