@tool
class_name LevelTransition extends Area2D

enum SIDE {
	LEFT,
	RIGHT,
	TOP,
	BOTTOM
}

@export_file("*.tscn") var target_level
@export var target_transition_point: String = "LevelTransition"
@export_category("Collision area settings")

@export_range(1,12, 1, "or_greater") var size: int = 2:
	set(_val):
		size = _val
		_update_area()

@export var side: SIDE = SIDE.LEFT:
	set(_val):
		side = _val
		_update_area()

@export var snap_to_grid: bool = true:
	set(_val):
		snap_to_grid = _val
		_snap_to_grid()

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	_update_area()
	if Engine.is_editor_hint():
		return
		
	monitoring = false
	_place_player()

	await LevelManager.level_load_finished
	
	monitoring = true
	body_entered.connect(_on_body_entered)

func _update_area() -> void:
	var new_rect: Vector2 = Vector2(16,16)
	var new_position: Vector2 = Vector2.ZERO

	if side == SIDE.TOP:
		new_rect.x *= size
		new_position.y -= (new_rect.y / 2)
	elif side == SIDE.BOTTOM:
		new_rect.x *= size
		new_position.y += (new_rect.y / 2)
	elif side == SIDE.LEFT:
		new_rect.y *= size
		new_position.x -= (new_rect.x / 2)
	elif side == SIDE.RIGHT:
		new_rect.y *= size
		new_position.x += (new_rect.x / 2)

	if !collision_shape:
		collision_shape = get_node("CollisionShape2D") as CollisionShape2D

	collision_shape.shape.size = new_rect
	collision_shape.position = new_position

func _snap_to_grid() -> void:
	if snap_to_grid:
		position.x = round(position.x / 16) * 16
		position.y = round(position.y / 16) * 16

func _on_body_entered(_p: Node2D) -> void:
	LevelManager.load_level(target_level, target_transition_point)
	
func _place_player() -> void:
	if name != LevelManager.target_transition_area:
		return
	print("Global position:", global_position)
	print("New position:", _new_position())
	PlayerManager.set_player_position(_new_position())

func _new_position() -> Vector2:
	var offset: Vector2 = Vector2.ZERO
	print(side)
	if side == SIDE.LEFT or side == SIDE.RIGHT:
		offset.y = global_position.y
		if side == SIDE.RIGHT:
			offset.x = global_position.x - 16
		else: 
			offset.x = global_position.x + 16
	else:
		offset.x = global_position.x
		if side == SIDE.BOTTOM:
			offset.y = global_position.y - 16
		else:
			offset.y = global_position.y + 32

	return offset
