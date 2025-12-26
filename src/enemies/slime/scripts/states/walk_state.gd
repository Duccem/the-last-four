class_name SlimeWalkState
extends EnemyState
@export var speed: float = 20

@onready var idle: EnemyState = $"../idle_state"
@onready var hurt: EnemyState = $"../hurt_state"

var on_range: bool = false
var _is_hurt: bool = false

func enter() -> void:
	enemy.anim_state.travel("jump")
	enemy.agro_range.body_exited.connect(stop_moving)
	enemy.hit_box.damaged.connect(receive_damage)

func process(_delta: float) -> EnemyState:
	if _is_hurt:
		_is_hurt = false
		return hurt
	if on_range == false:
		return idle
	
	enemy.velocity = enemy.direction.normalized() * speed
	enemy.animation_controller.set_animation_direction(enemy.direction)

	return null

func stop_moving(_area) -> void:
	on_range = false
	idle.on_range = false

func receive_damage(_area, _pos) -> void:
	_is_hurt = true

func exit():
	enemy.agro_range.body_exited.disconnect(stop_moving)
	if enemy.hit_box.damaged.is_connected(receive_damage):
		enemy.hit_box.damaged.disconnect(receive_damage)
