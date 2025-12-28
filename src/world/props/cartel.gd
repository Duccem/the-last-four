class_name Cartel extends Node2D

@onready var hitbox: Hitbox = $Hitbox

func _ready():
	hitbox.damaged.connect(take_damage)

func take_damage(_hurt_box: Hurtbox) -> void:
	queue_free()