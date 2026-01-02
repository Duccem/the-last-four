class_name  Enemy extends CharacterBody2D

@onready var state_machine: EnemyStateMachine = $state_machine
@onready var anim_tree: AnimationTree = $animator_tree
@onready var animation_controller: EnemyAnimationsController = $"animations_controller"
@onready var anim_player: AnimationPlayer = $animator
@onready var anim_state: AnimationNodeStateMachinePlayback = anim_tree.get("parameters/playback")
@onready var hit_box: Hitbox = $"hit_box"
@onready var hurt_box: Hurtbox = $"hurt_box"
@onready var audio: AudioStreamPlayer2D = $"audio/AudioStreamPlayer2D"

@export var health_points: int = 3

signal enemy_died(box: Hurtbox)
signal enemy_hurt(box: Hurtbox)

var player: Player

var direction : Vector2 = Vector2.ZERO
var invulnerable: bool = false

func _ready():
  player = PlayerManager.player
  state_machine.initialize(self)
  animation_controller.initialize(self)
  hit_box.damaged.connect(take_damage)

func _process(_delta) -> void:
  update_movement_input()

func _physics_process(_delta: float) -> void:
  move_and_slide()

func update_movement_input() -> void:
  if player == null:
    direction = Vector2.ZERO
    return
	
  var to_player: Vector2 = (player.global_position - global_position).normalized()
  direction = to_player

func take_damage(box: Hurtbox) -> void:
  if invulnerable:
    return
  health_points -= box.damage

  if health_points > 0:
    enemy_hurt.emit(box)
  else:
    enemy_died.emit(box)

func make_invulnerable(duration: float) -> void:
  invulnerable = true
  hit_box.monitoring = false
  await get_tree().create_timer(duration).timeout
  invulnerable = false
  hit_box.monitoring = true