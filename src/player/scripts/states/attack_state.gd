class_name StateAttack extends PlayerState

@onready var idle: PlayerState = $"../idle_state"
@onready var walk: PlayerState = $"../walk_state"
@onready var spear_hurt_box: Hurtbox = $"../../interactions/spear_hurtbox"

@export_range(1, 20, 0.5) var decelerate: float = 5.0
@export var attack_sound: AudioStream

var attacking: bool = false

func enter() -> void:
  player.animation_controller.change_sprite_animation("attack")
  player.anim_state.travel("attack")
  player.anim_tree.animation_finished.connect(end_attack)
  
  attacking = true

  await get_tree().create_timer(.5).timeout
  player.audio.stream = attack_sound
  player.audio.pitch_scale = randf_range(0.9, 1.1)
  player.audio.play()
  spear_hurt_box.monitoring = true

func end_attack(_anim_name: String) -> void:
  attacking = false
  

func process(_delta: float) -> PlayerState:
  player.velocity -= player.velocity * decelerate * _delta
  if not attacking:
    if player.direction == Vector2.ZERO:
      return idle
    else:
      return walk
  return null

func exit() -> void:
  player.anim_tree.animation_finished.disconnect(end_attack)
  spear_hurt_box.monitoring = false