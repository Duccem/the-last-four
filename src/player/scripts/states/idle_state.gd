class_name StateIdle extends PlayerState

@onready var walk: PlayerState = $"../walk_state"
@onready var attack: PlayerState = $"../attack_state"
@onready var hurt: PlayerState = $"../hurt_state"

var hitted: bool = false

func enter() -> void:
	player.animation_controller.change_sprite_animation("idle")
	player.anim_state.travel("idle")
	player.hit_box.damaged.connect(_on_damaged)

func process(_delta: float) -> PlayerState:
	player.velocity = Vector2.ZERO

	if hitted:
		hitted = false
		return hurt

	if player.direction != Vector2.ZERO:
		return walk
	return null

func handle_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("player_attack"):
		return attack
	return null

func exit():
	player.hit_box.damaged.disconnect(_on_damaged)
	pass

func _on_damaged(box: Hurtbox) -> void:
	hitted = true
	hurt.hurt_box = box

