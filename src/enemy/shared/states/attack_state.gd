class_name EnemyAttackState extends EnemyState

@onready var idle: EnemyState = $"../idle_state"
@onready var chase: EnemyState = $"../chase_state"

@export var attack_range: EnemyRange
@export_range(1, 20, 0.5) var decelerate: float = 5.0
@export var attack_sound: AudioStream

var attacking: bool = false

var on_range: bool = false

func init() -> void:
  if attack_range:
    attack_range.player_entered.connect(_on_body_entered_attack_range)
    attack_range.player_exited.connect(_on_body_exited_attack_range)

func enter() -> void:
  enemy.anim_state.travel("attack")
  
  attacking = true

  await get_tree().create_timer(.5).timeout
  enemy.audio.stream = attack_sound
  enemy.audio.pitch_scale = randf_range(0.9, 1.1)
  enemy.audio.play()
  enemy.hurt_box.monitoring = true

func process(_delta: float) -> EnemyState:
  enemy.velocity -= enemy.velocity * decelerate * _delta
  if not on_range:
    if chase.on_range:
      return chase
    else:
      return idle
  return null

func exit() -> void:
  enemy.hurt_box.monitoring = false


func _on_body_entered_attack_range() -> void:
  on_range = true
  if (state_machine.current_state is EnemyHurtState or state_machine.current_state is EnemyDeathState):
    return
  state_machine.change_state(self)

func _on_body_exited_attack_range() -> void:
  on_range = false
  attacking = false