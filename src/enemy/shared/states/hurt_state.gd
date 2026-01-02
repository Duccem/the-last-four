class_name EnemyHurtState
extends EnemyState

@export var recovery_fallback: float = 0.5
@export var hurt_sound: AudioStream

@onready var idle: EnemyState = $"../idle_state"
@onready var chase: EnemyState = $"../chase_state"
@onready var attack: EnemyState = get_node_or_null("../attack_state")

var next_state: EnemyState
var animation_finished: bool = false
var timer: float = 0.0

var damage_position: Vector2

func init() -> void:
	enemy.enemy_hurt.connect(_on_enemy_hurt)

func enter() -> void:
	enemy.anim_state.travel("hurt")
	enemy.animation_controller.set_animation_direction(enemy.direction)
	
	enemy.audio.stream = hurt_sound
	enemy.audio.pitch_scale = randf_range(0.9, 1.1)
	enemy.audio.play()
	enemy.make_invulnerable(recovery_fallback)
	
	enemy.velocity = Vector2.ZERO
	
	next_state = _pick_next_state()
	animation_finished = false
	timer = recovery_fallback
	if not enemy.anim_player.animation_finished.is_connected(_on_animation_finished):
		enemy.anim_player.animation_finished.connect(_on_animation_finished)

func process(delta: float) -> EnemyState:
	enemy.velocity = Vector2.ZERO
	timer -= delta
	if animation_finished or timer <= 0.0:
		return next_state

	var knockback_dir := -enemy.direction
	if knockback_dir != Vector2.ZERO:
		var knockback_factor := clampf(timer / recovery_fallback, 0.0, 1.0)
		var knockback_speed := 150.0
		enemy.velocity = knockback_dir.normalized() * knockback_speed * knockback_factor

	return null


func exit() -> void:
	if enemy.anim_player.animation_finished.is_connected(_on_animation_finished):
		enemy.anim_player.animation_finished.disconnect(_on_animation_finished)
	animation_finished = false
	
func _pick_next_state() -> EnemyState:
	if attack != null and attack.on_range:
		return attack
	if chase != null and chase.on_range:
		return chase
	return idle

func _on_enemy_hurt(box: Hurtbox) -> void:
	damage_position = box.global_position
	state_machine.change_state(self)

func _on_animation_finished(_anim_name: StringName) -> void:
	animation_finished = true