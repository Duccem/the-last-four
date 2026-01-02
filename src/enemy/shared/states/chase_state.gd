class_name EnemyChaseState
extends EnemyState
@export var speed: float = 20
@export_category("Detection")
@export var agro_range: EnemyRange

@onready var idle: EnemyState = $"../idle_state"

var on_range: bool = false

func init() -> void:
	if agro_range:
		agro_range.player_entered.connect(_on_player_entered)
		agro_range.player_exited.connect(_on_exit_range)


func enter() -> void:
	enemy.anim_state.travel("walk")

func process(_delta: float) -> EnemyState:
	if on_range == false:
		return idle

	var to_player: Vector2 = (enemy.player.global_position - enemy.global_position).normalized()
	enemy.direction = to_player
	enemy.changed_direction.emit(enemy.direction)
	
	enemy.velocity = enemy.direction.normalized() * speed
	enemy.animation_controller.set_animation_direction(enemy.direction)

	return null

func _on_player_entered() -> void:
	on_range = true
	if (state_machine.current_state is EnemyHurtState or state_machine.current_state is EnemyDeathState):
		return
	state_machine.change_state(self)

func _on_exit_range() -> void:
	print("Player exited agro range")
	on_range = false

