extends Node

signal level_load_started
signal level_load_finished

signal tile_map_bounds_changed(bounds: Array[Vector2])

var target_transition_area: String
var current_tilemap_bounds: Array[Vector2]

func _ready():
  await get_tree().process_frame

  level_load_finished.emit()

func change_tilemap_bounds(new_bounds: Array[Vector2]) -> void:
  current_tilemap_bounds = new_bounds
  tile_map_bounds_changed.emit(new_bounds)

func load_level(
  _level_path: String,
  _target_transition_area: String,
) -> void:
  get_tree().paused = true

  target_transition_area = _target_transition_area

  await SceneTransition.fade_out()

  level_load_started.emit()

  await get_tree().process_frame

  get_tree().change_scene_to_file(_level_path)

  await SceneTransition.fade_in()

  get_tree().paused = false

  await get_tree().process_frame

  level_load_finished.emit()