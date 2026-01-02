extends Node

const PLAYER = preload("res://src/player/player.tscn")
const INVENTORY: Inventory = preload("res://src/inventory/shared/resources/player_inventory.tres")
var player: Player

var player_spawned: bool = false

func _ready():
  add_player_instance()

func add_player_instance() -> void:
  player = PLAYER.instantiate()
  add_child(player)

func set_player_health(hp: int, max_hp: int) -> void:
  player.max_health_points = max_hp
  player.health_points = hp

func set_player_position(position: Vector2) -> void:
  player.global_position = position
  player_spawned = true

func set_parent_node(new_parent: Node) -> void:
  if player.get_parent():
    player.get_parent().remove_child(player)
  new_parent.add_child(player)

func un_parent_player(_p: Node2D) -> void:
  _p.remove_child(player)
