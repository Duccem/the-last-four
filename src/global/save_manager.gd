extends Node

const SAVE_PATH = "user://"

signal game_loaded
signal game_saved

var save_data: Dictionary = {
  scene_path = "",
  player = {
    hp = 1,
    max_hp = 1,
    pos_x = 0,
    pos_y = 0,
  },
  items = [],
  abilities = [],
  quests = [],
}


func save_game() -> void:
  update_player_data()
  update_scene_path()
  var file: FileAccess = FileAccess.open(SAVE_PATH + "savegame.sav", FileAccess.WRITE)
  var data_to_save: String = JSON.stringify(save_data)
  file.store_line(data_to_save)
  file.close()
  game_saved.emit()


func load_game() -> void:
  var file: FileAccess = FileAccess.open(SAVE_PATH + "savegame.sav", FileAccess.READ)
  if not file:
    push_error("No save file found!")
    return
  var data_loaded: String = file.get_line()
  save_data = JSON.parse_string(data_loaded)
  file.close()
  

  LevelManager.load_level(save_data.scene_path,"LoadPoint")

  await LevelManager.level_load_started

  PlayerManager.set_player_health(save_data.player.hp, save_data.player.max_hp)
  PlayerManager.set_player_position(Vector2(save_data.player.pos_x, save_data.player.pos_y))

  await LevelManager.level_load_finished

  game_loaded.emit()

func update_player_data() -> void:
  var player = PlayerManager.player
  save_data.player.hp = player.health_points
  save_data.player.max_hp = player.max_health_points
  save_data.player.pos_x = player.position.x
  save_data.player.pos_y = player.position.y

func update_scene_path() -> void:
  for c in get_tree().root.get_children():
    if c is Level:
      save_data.scene_path = c.scene_file_path