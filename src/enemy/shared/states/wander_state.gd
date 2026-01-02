class_name EnemyWanderState
extends EnemyState

@export var speed: float = 12.0
@export var min_change_time: float = 1.0
@export var max_change_time: float = 3.0
@export_range(0.0, 1.0) var idle_chance: float = 0.25

@onready var walk: EnemyState = $"../walk_state"
@onready var hurt: EnemyState = $"../hurt_state"

var time_left: float = 0.0
var direction: Vector2 = Vector2.ZERO
var chasing: bool = false
var is_hurt: bool = false


func enter() -> void:
	walk.on_range = false
	chasing = false
	enemy.anim_state.travel("idle")
	enemy.agro_range.body_entered.connect(_on_body_entered)
	enemy.hit_box.damaged.connect(_on_damaged)
	pick_new_direction()


func process(delta: float) -> EnemyState:

	if is_hurt:
		is_hurt = false
		return walk

	if chasing:
		walk.on_range = true
		return walk

	time_left -= delta
	if time_left <= 0.0:
		pick_new_direction()

	enemy.velocity = direction * speed
	if direction != Vector2.ZERO:
		enemy.animation_controller.set_animation_direction(direction)

	return null


func exit() -> void:
	if enemy.agro_range.body_entered.is_connected(_on_body_entered):
		enemy.agro_range.body_entered.disconnect(_on_body_entered)

	if enemy.hit_box.damaged.is_connected(_on_damaged):
		enemy.hit_box.damaged.disconnect(_on_damaged)
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

func _on_damaged(_hurt_box: Hurtbox) -> void:
	is_hurt = true

func _on_body_entered(_body: Node2D) -> void:
	chasing = true
	walk.on_range = true

