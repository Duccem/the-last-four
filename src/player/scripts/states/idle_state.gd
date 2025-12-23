class_name StateIdle extends PlayerState

@onready var walk: PlayerState = $"../walk_state"
@onready var attack: PlayerState = $"../attack_state"

var input_movement: Vector2 = Vector2.ZERO

func enter() -> void:
	player.animation_controller.change_sprite_animation("idle")
	player.anim_state.travel("idle")

func process(_delta: float) -> PlayerState:
	player.velocity = Vector2.ZERO
	if player.direction != Vector2.ZERO:
		return walk
	return null

func handle_input(_event: InputEvent) -> PlayerState:
	if _event.is_action_pressed("player_attack"):
		return attack
	return null

