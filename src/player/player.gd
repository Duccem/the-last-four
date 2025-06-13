extends CharacterBody2D
class_name Player
@export var state_machine: PlayerStateMachine
@export var current_selected: bool = false
@export var run_speed: float = 90
@export var companion_position: int = 1
@export var target_player: CharacterBody2D = null

func _ready():
  if not current_selected:
    target_player = target_player if target_player != null else get_parent().get_node("player")

