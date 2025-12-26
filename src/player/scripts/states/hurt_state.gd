class_name PlayerHurtState extends PlayerState

@export var recovery_fallback: float = 0.5

@onready var idle: PlayerState = $"../idle_state"
@onready var walk: PlayerState = $"../walk_state"
@onready var attack: PlayerState = $"../attack_state"

var _next_state: PlayerState
var _animation_finished: bool = false
var _timer: float = 0.0
var _enemy_pos: Vector2

func enter():
  player.anim_player.play("hurt")
  player.animation_controller.set_animation_direction(player.direction)
  player.anim_tree.active = false
  _next_state = _pick_next_state()
  _animation_finished = false
  _timer = recovery_fallback
  player.velocity = Vector2.ZERO
  if not player.anim_player.animation_finished.is_connected(_on_animation_finished):
    player.anim_player.animation_finished.connect(_on_animation_finished)

func process(delta: float) -> PlayerState:
  player.velocity = Vector2.ZERO
  _timer -= delta
  if _animation_finished or _timer <= 0.0:
    return _next_state
  
  var knockback_dir := -player.direction if player.direction != Vector2.ZERO else (player.global_position - _enemy_pos)
  var knockback_factor := clampf(_timer / recovery_fallback, 0.0, 1.0)
  var knockback_speed := 150.0

  player.velocity = knockback_dir.normalized() * knockback_speed * knockback_factor
    
  return null

func exit() -> void:
  if player.anim_player.animation_finished.is_connected(_on_animation_finished):
    player.anim_player.animation_finished.disconnect(_on_animation_finished)
  player.anim_player.stop()
  player.anim_tree.active = true
  _animation_finished = false

func _pick_next_state() -> PlayerState:
  if walk != null and player.direction != Vector2.ZERO:
    return walk
  return idle

func _on_animation_finished(_anim_name: String) -> void:
  _animation_finished = true