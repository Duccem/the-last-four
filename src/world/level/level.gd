class_name Level extends Node2D

func _ready():
  self.y_sort_enabled = true
  PlayerManager.set_parent_node(self)
  LevelManager.level_load_started.connect(_free_level)

func _free_level() -> void:
  PlayerManager.un_parent_player(self)
  queue_free()