class_name EnemyDeathState extends EnemyState

var animation_finished: bool = false

func enter() -> void:
  enemy.anim_state.travel("death")
  enemy.velocity = Vector2.ZERO
  enemy.anim_tree.animation_finished.connect(_on_animation_finished)

func process(_delta: float) -> EnemyState:
  enemy.velocity = Vector2.ZERO
  if animation_finished:
    enemy.queue_free()
  return null


func _on_animation_finished(_anim_name: StringName) -> void:
  animation_finished = true