class_name EnemyIdleState
extends EnemyState
@onready var wander: EnemyState = $"../wander_state"

@export var wander_delay: float = 2.0

var time_left: float = 0.0
var is_hurt: bool = false

func enter() -> void:
	enemy.anim_state.travel("idle")
	time_left = wander_delay

func process(_delta: float) -> EnemyState:
	enemy.velocity = Vector2.ZERO
	time_left -= _delta
	if time_left <= 0.0:
		return wander
	return null

	
