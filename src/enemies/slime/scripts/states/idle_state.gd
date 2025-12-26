class_name SlimeIdleState
extends EnemyState

@onready var walk: EnemyState = $"../walk_state"
@onready var wander: EnemyState = $"../wander_state"
@onready var hurt: EnemyState = $"../hurt_state"

var on_range: bool = false
@export var wander_delay: float = 2.0

var _time_left: float = 0.0
var _is_hurt: bool = false


func enter() -> void:
	enemy.anim_state.travel("idle")
	enemy.agro_range.body_entered.connect(change_direction)
	enemy.hit_box.area_entered.connect(receive_damage)
	_time_left = wander_delay

func process(_delta: float) -> EnemyState:
	enemy.velocity = Vector2.ZERO
	if _is_hurt:
		_is_hurt = false
		return hurt
	if on_range:
		return walk
	_time_left -= _delta
	if _time_left <= 0.0:
		return wander
	return null

func change_direction(_area) -> void:
	on_range = true
	walk.on_range = true

func receive_damage(_area: Area2D) -> void:
	_is_hurt = true
	
	
func exit():
	enemy.agro_range.body_entered.disconnect(change_direction)
	if enemy.hit_box.area_entered.is_connected(receive_damage):
		enemy.hit_box.area_entered.disconnect(receive_damage)