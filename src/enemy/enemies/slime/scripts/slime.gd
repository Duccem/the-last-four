class_name Slime extends Enemy

@onready var agro_range: Area2D = $"interactions/agro_range"

func update_movement_input() -> void:
	if player == null:
		direction = Vector2.ZERO
		return
	
	var to_player: Vector2 = (player.global_position - global_position).normalized()
	direction = to_player