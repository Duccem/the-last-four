extends PlayerState
var input_movement: Vector2 = Vector2.ZERO

func enter(_previous_state_path: String, _data := {}) -> void:
	player.velocity= Vector2.ZERO
	change_animation.emit("idle")

func physics_update(_delta: float) -> void:
	input_movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_movement != Vector2.ZERO:
		finished.emit(posible_states.Walk)
