class_name EnemyAnimationsController extends Node2D

var enemy : Enemy

func initialize(_enemy: Enemy) -> void:
  enemy = _enemy

func set_animation_direction(_dir: Vector2) -> void:
  pass