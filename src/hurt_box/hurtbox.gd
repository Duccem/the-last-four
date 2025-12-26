class_name Hurtbox extends Area2D

@export var damage: int = 1

func _ready():
	area_entered.connect(give_damage)

func give_damage(area: Area2D) -> void:
	print("Hurtbox hit: %s" % area.name)
	if area is Hitbox:
		area.take_damage(damage)