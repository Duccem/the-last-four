extends PlayerState
var input_movement: Vector2 = Vector2.ZERO


func enter(_previous_state_path: String, _data := {}) -> void:
	change_animation.emit("walk")

func physics_update(_delta: float) -> void:
	if player.current_selected:
		selected_player()
	else:
		companion_player()

func selected_player() -> void:
	input_movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_movement != Vector2.ZERO:
		set_animation_direction(input_movement)
		player.velocity = input_movement.normalized() * player.run_speed
		player.move_and_slide()
	else:
		finished.emit(posible_states.Idle)

func companion_player() -> void:
	if player.position.distance_to(player.target_player.global_position) > 30 * player.companion_position:
		var dir = (player.target_player.global_position - player.position).normalized()
		set_animation_direction(dir)
		player.velocity = dir * player.run_speed
		player.move_and_slide()
	else:
		print("Target reached, stopping movement")
		finished.emit(posible_states.Idle)
		

func set_animation_direction(dir: Vector2) -> void:
	anim_tree.set("parameters/idle/blend_position", dir)
	anim_tree.set("parameters/walk/blend_position", dir)