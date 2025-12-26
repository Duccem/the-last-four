class_name PlayerWalkState
extends PlayerState
@export var speed: float = 100.0

@onready var idle: PlayerState = $"../idle_state"
@onready var attack: PlayerState = $"../attack_state"
@onready var hurt: PlayerState = $"../hurt_state"

var hitted: bool = false

func enter() -> void:
	player.animation_controller.change_sprite_animation("walk")
	player.anim_state.travel("walk")
	player.hit_box.damaged.connect(_on_damaged)

func process(_delta: float) -> PlayerState:

	if hitted:
		hitted = false
		return hurt

	if player.direction == Vector2.ZERO:
		return idle
	
	player.velocity = player.direction * speed
	player.animation_controller.set_animation_direction(player.direction)

	return null

func handle_input(event: InputEvent) -> PlayerState:
	if event.is_action_pressed("player_attack"):
		return attack
	return null

func exit():
	player.hit_box.damaged.disconnect(_on_damaged)

func _on_damaged(box: Hurtbox) -> void:
	hitted = true
	hurt._enemy_pos = box.global_position

