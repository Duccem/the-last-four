class_name StateIdle extends PlayerState

@onready var walk: PlayerState = $"../walk_state"
@onready var attack: PlayerState = $"../attack_state"
@onready var hurt: PlayerState = $"../hurt_state"

var hitted: bool = false

func enter() -> void:
	player.animation_controller.change_sprite_animation("idle")
	player.anim_state.travel("idle")
	player.hit_box.damaged.connect(get_hurt)

func process(_delta: float) -> PlayerState:
	player.velocity = Vector2.ZERO

	if hitted:
		hitted = false
		return hurt

	if player.direction != Vector2.ZERO:
		return walk
	return null

func handle_input(_event: InputEvent) -> PlayerState:
	if _event.is_action_pressed("player_attack"):
		return attack
	return null

func exit():
	player.hit_box.damaged.disconnect(get_hurt)
	pass

func get_hurt(_amount: float, pos: Vector2) -> void:
	hitted = true
	hurt._enemy_pos = pos

