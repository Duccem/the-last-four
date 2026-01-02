class_name EnemyWanderState
extends EnemyState

@export var speed: float = 12.0
@export var min_change_time: float = 1.0
@export var max_change_time: float = 3.0
@export_range(0.0, 1.0) var idle_chance: float = 0.25

@onready var chase: EnemyState = $"../chase_state"

var time_left: float = 0.0
var direction: Vector2 = Vector2.ZERO

func enter() -> void:
	enemy.anim_state.travel("idle")
	pick_new_direction()

func process(delta: float) -> EnemyState:

	time_left -= delta
	if time_left <= 0.0:
		pick_new_direction()

	enemy.velocity = direction * speed
	if direction != Vector2.ZERO:
		enemy.animation_controller.set_animation_direction(direction)

	return null

func exit() -> void:
	enemy.velocity = Vector2.ZERO

func pick_new_direction() -> void:
	time_left = randf_range(min_change_time, max_change_time)
	direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
	if direction.length_squared() <= 0.01 or randf() < idle_chance:
		direction = Vector2.ZERO
		enemy.anim_state.travel("idle")
	else:
		direction = direction.normalized()
		enemy.anim_state.travel("walk")
		enemy.animation_controller.set_animation_direction(direction)


