class_name SlimeAnimationsController extends EnemyAnimationsController

func set_animation_direction(dir: Vector2) -> void:
  enemy.anim_tree.set("parameters/idle/blend_position", dir)
  enemy.anim_tree.set("parameters/jump/blend_position", dir)
  enemy.anim_tree.set("parameters/hurt/blend_position", dir)
