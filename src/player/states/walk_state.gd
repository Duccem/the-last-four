extends PlayerState
var input_movement: Vector2 = Vector2.ZERO
const SPEED: float = 90

func enter(_previous_state_path: String, _data := {}) -> void:
	change_animation.emit("walk")

func physics_update(_delta: float) -> void:
	input_movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_movement != Vector2.ZERO:
		anim_tree.set("parameters/idle/blend_position", input_movement)
		anim_tree.set("parameters/walk/blend_position", input_movement)
		player.velocity = input_movement.normalized() * SPEED
		player.move_and_slide()
	else:
		finished.emit(posible_states.Idle)