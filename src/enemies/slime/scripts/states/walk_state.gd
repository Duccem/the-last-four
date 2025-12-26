class_name SlimeWalkState
extends EnemyState
@export var speed: float = 20

@onready var idle: EnemyState = $"../idle_state"

var on_range: bool = false

func enter() -> void:
	enemy.anim_state.travel("jump")
	enemy.agro_range.body_exited.connect(stop_moving)

func process(_delta: float) -> EnemyState:
	if on_range == false:
		return idle
	
	enemy.velocity = enemy.direction.normalized() * speed
	enemy.animation_controller.set_animation_direction(enemy.direction)

	return null

func stop_moving(_area) -> void:
	on_range = false
	idle.on_range = false

func exit():
	enemy.agro_range.body_exited.disconnect(stop_moving)
