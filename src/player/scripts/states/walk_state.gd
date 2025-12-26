class_name PlayerWalkState
extends PlayerState
@export var speed: float = 100.0

@onready var idle: PlayerState = $"../idle_state"

func enter() -> void:
	player.animation_controller.change_sprite_animation("walk")
	player.anim_state.travel("walk")

func process(_delta: float) -> PlayerState:
	if player.direction == Vector2.ZERO:
		return idle
	
	player.velocity = player.direction * speed
	player.animation_controller.set_animation_direction(player.direction)

	return null
