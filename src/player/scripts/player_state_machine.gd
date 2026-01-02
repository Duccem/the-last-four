extends Node
class_name PlayerStateMachine

var states: Array[PlayerState]
var previous_state: PlayerState
var current_state: PlayerState

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta):
	change_state(current_state.process(delta))

func _physics_process(delta):
	change_state(current_state.physics(delta))

func _unhandled_input(event):
	change_state(current_state.handle_input(event))

func initialize(player: Player) -> void:
	states = []
	for s in get_children():
		if s is PlayerState:
			states.append(s)
	
	if states.size() > 0:
		states[0].player = player
		change_state(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT

func change_state(new_state: PlayerState) -> void:
	if new_state == null || new_state == current_state:
		return
	
	if current_state:
		current_state.exit()
	
	previous_state = current_state
	current_state = new_state
	current_state.enter()

