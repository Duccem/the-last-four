class_name PlayerHurtState extends PlayerState

@export var recovery_fallback: float = 0.5
@export var hurt_sound: AudioStream

@onready var idle: PlayerState = $"../idle_state"
@onready var walk: PlayerState = $"../walk_state"
@onready var attack: PlayerState = $"../attack_state"

var next_state: PlayerState
var animation_finished: bool = false
var timer: float = 0.0
var hurt_box: Hurtbox

func enter():
  player.anim_player.play("hurt")
  player.animation_controller.set_animation_direction(player.direction)
  player.anim_tree.active = false

  player.audio.stream = hurt_sound
  player.audio.pitch_scale = randf_range(0.9, 1.1)
  player.audio.play()

  player.take_damage(hurt_box.damage)
  player.make_invulnerable(recovery_fallback)
  player.velocity = Vector2.ZERO

  next_state = _pick_next_state()
  animation_finished = false
  timer = recovery_fallback
  if not player.anim_player.animation_finished.is_connected(_on_animation_finished):
    player.anim_player.animation_finished.connect(_on_animation_finished)

func process(delta: float) -> PlayerState:
  player.velocity = Vector2.ZERO
  timer -= delta
  if animation_finished or timer <= 0.0:
    return next_state
  
  var knockback_dir := -player.direction if player.direction != Vector2.ZERO else (player.global_position - hurt_box.global_position)
  var knockback_factor := clampf(timer / recovery_fallback, 0.0, 1.0)
  var knockback_speed := 150.0

  player.velocity = knockback_dir.normalized() * knockback_speed * knockback_factor
    
  return null

func exit() -> void:
  if player.anim_player.animation_finished.is_connected(_on_animation_finished):
    player.anim_player.animation_finished.disconnect(_on_animation_finished)
  player.anim_player.stop()
  player.anim_tree.active = true
  player.invulnerable = false
  animation_finished = false

func _pick_next_state() -> PlayerState:
  if walk != null and player.direction != Vector2.ZERO:
    return walk
  return idle

func _on_animation_finished(_anim_name: String) -> void:
  animation_finished = true