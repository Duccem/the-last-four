extends CharacterBody2D
class_name Player
@onready var state_machine: PlayerStateMachine = $state_machine
@onready var animation_controller: AnimationController = $"animations"
@onready var anim_tree: AnimationTree = $animator_tree
@onready var anim_player: AnimationPlayer = $animator
@onready var anim_state: AnimationNodeStateMachinePlayback = anim_tree.get("parameters/playback")

var direction : Vector2 = Vector2.ZERO

func _ready():
  state_machine.initialize(self)
  animation_controller.initialize(self)

func _process(_delta) -> void:
  update_movement_input()

func _physics_process(_delta) -> void:
  move_and_slide()

func update_movement_input() -> void:
  direction = Input.get_vector("player_left", "player_right", "player_up", "player_down").normalized()