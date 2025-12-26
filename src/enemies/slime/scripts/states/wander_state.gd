class_name SlimeWanderState
extends EnemyState

@export var speed: float = 12.0
@export var min_change_time: float = 1.0
@export var max_change_time: float = 3.0
@export_range(0.0, 1.0) var idle_chance: float = 0.25

@onready var walk: SlimeWalkState = $"../walk_state"

var _time_left: float = 0.0
var _direction: Vector2 = Vector2.ZERO
var _chasing: bool = false


func enter() -> void:
	walk.on_range = false
	_chasing = false
	enemy.anim_state.travel("idle")
	enemy.agro_range.body_entered.connect(_on_body_entered)
	_pick_new_direction()


func process(delta: float) -> EnemyState:
	if _chasing:
		walk.on_range = true
		return walk

	_time_left -= delta
	if _time_left <= 0.0:
		_pick_new_direction()

	enemy.velocity = _direction * speed
	if _direction != Vector2.ZERO:
		enemy.animation_controller.set_animation_direction(_direction)

	return null


func exit() -> void:
	if enemy.agro_range.body_entered.is_connected(_on_body_entered):
		enemy.agro_range.body_entered.disconnect(_on_body_entered)
	enemy.velocity = Vector2.ZERO


func _pick_new_direction() -> void:
	_time_left = randf_range(min_change_time, max_change_time)
	_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
	if _direction.length_squared() <= 0.01 or randf() < idle_chance:
		_direction = Vector2.ZERO
		enemy.anim_state.travel("idle")
	else:
		_direction = _direction.normalized()
		enemy.anim_state.travel("jump")
		enemy.animation_controller.set_animation_direction(_direction)


func _on_body_entered(_body: Node2D) -> void:
	_chasing = true
	walk.on_range = true

