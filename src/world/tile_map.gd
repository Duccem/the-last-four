class_name LevelTileMap extends TileMap

func _ready() -> void:
  LevelManager.change_tilemap_bounds(get_tile_map_bounds())

func get_tile_map_bounds() -> Array[Vector2]:
  return [
    Vector2(0,0),
    Vector2(get_used_rect().size * rendering_quadrant_size)
  ]