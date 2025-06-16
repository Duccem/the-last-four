extends Node2D
class_name AnimationController

var sprite_animations: Array[Sprite2D] = []

func _ready():
	for child in get_children():
		if child is Sprite2D:
			sprite_animations.append(child)

func change_sprite_animation(new_name: StringName):
	if not sprite_animations.is_empty():
		for sprite in sprite_animations:
			if sprite.name == new_name:
				sprite.visible = true
			else:
				sprite.visible = false
