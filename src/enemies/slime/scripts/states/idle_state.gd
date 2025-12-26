class_name SlimeIdleState
extends EnemyState

@onready var walk: EnemyState = $"../walk_state"
@onready var wander: EnemyState = $"../wander_state"

var on_range: bool = false
@export var wander_delay: float = 2.0

var _time_left: float = 0.0


func enter() -> void:
	enemy.anim_state.travel("idle")
	enemy.agro_range.body_entered.connect(change_direction)
	_time_left = wander_delay
	print("Entered Idle State")

func process(_delta: float) -> EnemyState:
	enemy.velocity = Vector2.ZERO
	if on_range:
		return walk
	_time_left -= _delta
	if _time_left <= 0.0:
		return wander
	return null

func change_direction(_area) -> void:
	on_range = true
	walk.on_range = true
	
func exit():
	enemy.agro_range.body_entered.disconnect(change_direction)