class_name Hitbox extends Area2D

signal damaged(amount: int)

func take_damage(amount: int) -> void:
	damaged.emit(amount)
