class_name PlayerInteractions extends Node2D

func update_direction(new_direction: Vector2) -> void:
  if new_direction == Vector2.ZERO:
    return
  rotation = new_direction.angle() - PI / 2
