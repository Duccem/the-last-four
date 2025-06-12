extends Node
class_name PlayerState


var player: CharacterBody2D
var anim_tree: AnimationTree

const posible_states = {
	Idle = "idle_state",
	Walk = "walk_state",
	Attack = "attack_state",
	Dash = "dash_state",
}

signal finished(next_state_name: String, data: Dictionary)
signal change_animation(animation_name: String)

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func enter(_previous_state_name: String, _data:={}) -> void:
	pass

func exit():
	pass
