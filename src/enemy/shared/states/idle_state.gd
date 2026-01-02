class_name EnemyIdleState
extends EnemyState

@onready var walk: EnemyState = $"../walk_state"
@onready var wander: EnemyState = $"../wander_state"
@onready var hurt: EnemyState = $"../hurt_state"

var on_range: bool = false
@export var wander_delay: float = 2.0

var time_left: float = 0.0
var is_hurt: bool = false


func enter() -> void:
	enemy.anim_state.travel("idle")
	enemy.agro_range.body_entered.connect(change_direction)
	enemy.hit_box.damaged.connect(_on_damaged)
	time_left = wander_delay

func process(_delta: float) -> EnemyState:
	enemy.velocity = Vector2.ZERO
	if is_hurt:
		is_hurt = false
		return hurt
	if on_range:
		return walk
	time_left -= _delta
	if time_left <= 0.0:
		return wander
	return null

func change_direction(_area) -> void:
	on_range = true
	walk.on_range = true

func exit():
	enemy.agro_range.body_entered.disconnect(change_direction)
	if enemy.hit_box.damaged.is_connected(_on_damaged):
		enemy.hit_box.damaged.disconnect(_on_damaged)

func _on_damaged(_box: Hurtbox) -> void:
	is_hurt = true
	hurt.hurt_box = _box
	
