class_name  Enemy extends CharacterBody2D

@onready var state_machine: EnemyStateMachine = $state_machine
@onready var anim_tree: AnimationTree = $animator_tree
@onready var animation_controller: EnemyAnimationsController = $"animations_controller"
@onready var anim_player: AnimationPlayer = $animator
@onready var anim_state: AnimationNodeStateMachinePlayback = anim_tree.get("parameters/playback")
@onready var hit_box: Hitbox = $"interactions/hit_box"
@onready var hurt_box: Hurtbox = $"interactions/hurt_box"
@onready var audio: AudioStreamPlayer2D = $"audio/AudioStreamPlayer2D"


@export var health_points: int = 3
@export var player: Player

var direction : Vector2 = Vector2.ZERO
var invulnerable: bool = false

func _ready():
  state_machine.initialize(self)
  animation_controller.initialize(self)

func _process(_delta) -> void:
  update_movement_input()

func _physics_process(_delta: float) -> void:
  move_and_slide()

func update_movement_input() -> void:
  pass

func receive_damage(damage: int) -> void:
  if invulnerable:
    return
  health_points -= damage