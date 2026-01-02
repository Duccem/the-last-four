extends Node
class_name EnemyState

var enemy: Enemy
var state_machine: EnemyStateMachine

func init() -> void:
	pass

func handle_input(_event: InputEvent) -> EnemyState:
	return null

func process(_delta: float) -> EnemyState:
	return null

func physics(_delta: float) -> EnemyState:
	return null

func enter() -> void:
	pass

func exit():
	pass