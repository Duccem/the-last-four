class_name Hurtbox extends Area2D

@export var damage: int = 1

func _ready():
	area_entered.connect(give_damage)

func give_damage(area: Area2D) -> void:
	if area is Hitbox:
		var pos_body = self.get_parent().get_parent() as CharacterBody2D
		area.take_damage(damage, pos_body.global_position)