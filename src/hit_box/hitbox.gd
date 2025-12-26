class_name Hitbox extends Area2D

signal damaged(amount: int, source_pos: Vector2)

func take_damage(amount: int, source_pos: Vector2) -> void:
	damaged.emit(amount, source_pos)
