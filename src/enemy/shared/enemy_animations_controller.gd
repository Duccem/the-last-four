class_name EnemyAnimationsController extends Node2D

var enemy : Enemy

func initialize(_enemy: Enemy) -> void:
  enemy = _enemy

func set_animation_direction(dir: Vector2) -> void:
  enemy.anim_tree.set("parameters/idle/blend_position", dir)
  enemy.anim_tree.set("parameters/walk/blend_position", dir)
  enemy.anim_tree.set("parameters/hurt/blend_position", dir)