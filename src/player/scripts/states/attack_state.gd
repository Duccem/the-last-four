class_name StateAttack extends PlayerState

@onready var idle: PlayerState = $"../idle_state"
@onready var walk: PlayerState = $"../walk_state"

@export_range(1, 20, 0.5) var decelerate: float = 5.0

var attacking: bool = false

func enter() -> void:
  player.animation_controller.change_sprite_animation("attack")
  player.anim_state.travel("attack")
  player.anim_tree.animation_finished.connect(end_attack)
  attacking = true

func end_attack(_anim_name: String) -> void:
  print("Attack animation finished", _anim_name)
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