class_name EnemyRange extends Area2D

signal player_entered
signal player_exited

@onready var enemy: Enemy = get_parent() as Enemy

func _ready():
  body_entered.connect(_on_body_entered)
  body_exited.connect(_on_body_exited)
  setup()

func _on_body_entered(body: Node2D) -> void:
  if body is Player:
    player_entered.emit()

func _on_body_exited(body: Node2D) -> void:
  if body is Player:
    player_exited.emit()

func setup() -> void:
  pass