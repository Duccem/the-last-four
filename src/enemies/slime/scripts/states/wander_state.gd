class_name SlimeWanderState
extends EnemyState

@export var speed: float = 12.0
@export var min_change_time: float = 1.0
@export var max_change_time: float = 3.0
@export_range(0.0, 1.0) var idle_chance: float = 0.25

@onready var walk: EnemyState = $"../walk_state"
@onready var hurt: EnemyState = $"../hurt_state"

var _time_left: float = 0.0
var _direction: Vector2 = Vector2.ZERO
var _chasing: bool = false
var _is_hurt: bool = false


func enter() -> void:
	walk.on_range = false
	_chasing = false
	enemy.anim_state.travel("idle")
	enemy.agro_range.body_entered.connect(_on_body_entered)
	enemy.hit_box.damaged.connect(receive_damage)
	_pick_new_direction()


func process(delta: float) -> EnemyState:

	if _is_hurt:
		_is_hurt = false
		return walk

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

	if enemy.hit_box.damaged.is_connected(receive_damage):
		enemy.hit_box.damaged.disconnect(receive_damage)
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

func receive_damage(_area) -> void:
	_is_hurt = true

func _on_body_entered(_body: Node2D) -> void:
	_chasing = true
	walk.on_range = true

