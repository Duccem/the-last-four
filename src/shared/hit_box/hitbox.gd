class_name Hitbox extends Area2D

signal damaged(hurt_box: Hurtbox)

func take_damage(hurt_box: Hurtbox) -> void:
	damaged.emit(hurt_box)
