class_name SlimeWalkState
extends EnemyState
@export var speed: float = 20

@onready var idle: EnemyState = $"../idle_state"
@onready var hurt: EnemyState = $"../hurt_state"

var on_range: bool = false
var is_hurt: bool = false

func enter() -> void:
	enemy.anim_state.travel("jump")
	enemy.agro_range.body_exited.connect(_on_enter_range)
	enemy.hit_box.damaged.connect(_on_damaged)

func process(_delta: float) -> EnemyState:
	if is_hurt:
		is_hurt = false
		return hurt
	if on_range == false:
		return idle
	
	enemy.velocity = enemy.direction.normalized() * speed
	enemy.animation_controller.set_animation_direction(enemy.direction)

	return null

func exit():
	enemy.agro_range.body_exited.disconnect(_on_enter_range)
	if enemy.hit_box.damaged.is_connected(_on_damaged):
		enemy.hit_box.damaged.disconnect(_on_damaged)


func _on_enter_range(_area) -> void:
	on_range = false
	idle.on_range = false

func _on_damaged(box: Hurtbox) -> void:
	is_hurt = true
	hurt.hurt_box = box