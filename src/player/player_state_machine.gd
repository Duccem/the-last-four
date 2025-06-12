extends Node
class_name PlayerStateMachine

@export var player: CharacterBody2D
@export var anim_tree: AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

@export var initial_state: PlayerState
@onready var current_state: PlayerState = (func get_initial_state() -> PlayerState:
	return initial_state if initial_state != null else get_child(0)
).call()

var states: Array[PlayerState]

func _ready():
	for child in get_children():
		if child is PlayerState:
			states.append(child)
			child.player = player
			child.anim_tree = anim_tree
			child.finished.connect(self._on_state_finished)
			child.change_animation.connect(self._on_change_animation)
	current_state.enter("")

func _unhandled_input(event: InputEvent) -> void:
	current_state.handle_input(event)


func _process(delta: float) -> void:
	current_state.update(delta)


func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)


func _on_state_finished(next_state_name: String, data: Dictionary = {}) -> void:
	if not has_node(next_state_name):
		print("State not found:", next_state_name)
		return
	var previous_state_name = current_state.name
	current_state.exit()
	current_state = get_node(next_state_name)
	current_state.enter(previous_state_name, data)

func _on_change_animation(animation_name: String) -> void:
	if anim_state != null:
		anim_state.travel(animation_name)
	else:
		print("AnimationTree not set or invalid.")
		return
	print("Changed animation to:", animation_name)