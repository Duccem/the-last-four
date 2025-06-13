extends PlayerState
var input_movement: Vector2 = Vector2.ZERO

func enter(_previous_state_path: String, _data := {}) -> void:
	player.velocity= Vector2.ZERO
	change_animation.emit("idle")

func physics_update(_delta: float) -> void:
	if player.current_selected:
		selected_player()
	else:
		companion_player()

func selected_player() -> void:
	input_movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_movement != Vector2.ZERO:
		finished.emit(posible_states.Walk)

func companion_player() -> void:
	await get_tree().physics_frame
	if player.position.distance_to(player.target_player.global_position) > 30:
		print("Target not reached, moving to companion player position")
		finished.emit(posible_states.Walk)
