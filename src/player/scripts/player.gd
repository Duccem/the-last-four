extends CharacterBody2D
class_name Player
@onready var state_machine: PlayerStateMachine = $state_machine
@onready var animation_controller: AnimationController = $"animations"
@onready var audio: AudioStreamPlayer2D = $"audio/AudioStreamPlayer2D"
@onready var anim_tree: AnimationTree = $animator_tree
@onready var anim_player: AnimationPlayer = $animator
@onready var anim_state: AnimationNodeStateMachinePlayback = anim_tree.get("parameters/playback")
@onready var hit_box: Hitbox = $"interactions/hit_box"
@onready var spear_hit_box: Hurtbox = $"interactions/spear_hurtbox"

@export var health_points: int = 12
@export var max_health_points: int = 12
@export var health_regeneration_rate: float = 5.0

var health_regeneration_timer: float = 0.0


var direction : Vector2 = Vector2.ZERO
var invulnerable: bool = false

func _ready():
  state_machine.initialize(self)
  animation_controller.initialize(self)
  PlayerHud.update_hp(health_points, max_health_points)

func _process(_delta) -> void:
  health_regeneration_timer += _delta
  if health_regeneration_timer >= health_regeneration_rate:
    health_regeneration_timer = 0.0
    if health_points < max_health_points:
      health_points += 1
      PlayerHud.update_hp(health_points, max_health_points)
  update_movement_input()

func _physics_process(_delta) -> void:
  move_and_slide()

func update_movement_input() -> void:
  direction = Input.get_vector("player_left", "player_right", "player_up", "player_down").normalized()

func take_damage(damage_amount: int) -> void:
  if invulnerable:
    return
  health_points -= damage_amount
  health_regeneration_timer = 0.0
  PlayerHud.update_hp(health_points, max_health_points)

func make_invulnerable(duration: float) -> void:
  invulnerable = true
  hit_box.monitoring = false

  await get_tree().create_timer(duration).timeout
  invulnerable = false
  hit_box.monitoring = true