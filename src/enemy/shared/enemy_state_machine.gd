extends Node
class_name EnemyStateMachine

var states: Array[EnemyState]
var previous_state: EnemyState
var current_state: EnemyState

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta):
	change_state(current_state.process(delta))

func _physics_process(delta):
	change_state(current_state.physics(delta))

func _unhandled_input(event):
	change_state(current_state.handle_input(event))

func initialize(enemy: Enemy) -> void:
	states = []
	for s in get_children():
		if s is EnemyState:
			states.append(s)

	for state in states:
		state.enemy = enemy
			
	if states.size() > 0:
		change_state(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT

func change_state(new_state: EnemyState) -> void:
	if new_state == null || new_state == current_state:
		return
	
	if current_state:
		current_state.exit()
	
	previous_state = current_state
	current_state = new_state
	current_state.enter()
