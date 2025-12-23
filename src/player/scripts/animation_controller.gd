extends Node2D
class_name AnimationController

var sprite_animations: Array[Sprite2D] = []
var player: Player

func _ready():
	for child in get_children():
		if child is Sprite2D:
			sprite_animations.append(child)

func initialize(_player: Player) -> void:
	player = _player

func change_sprite_animation(new_name: StringName):
	if not sprite_animations.is_empty():
		for sprite in sprite_animations:
			if sprite.name == new_name:
				sprite.visible = true
			else:
				sprite.visible = false

func set_animation_direction(dir: Vector2) -> void:
	player.anim_tree.set("parameters/idle/blend_position", dir)
	player.anim_tree.set("parameters/walk/blend_position", dir)
	player.anim_tree.set("parameters/attack/blend_position", dir)