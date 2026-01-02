@tool
class_name TreasureChest extends Node2D

@onready var sprite: Sprite2D = $ItemSprite
@onready var label: Label = $ItemSprite/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interact_area: Area2D = $Area2D
@onready var is_open_data: PersistenceNode = $IsOpen

@export var item: Item:
  set(value):
    item = value
    _update_texture()

# El setter se encarga de validar la cantidad y de actualizar la etiqueta tanto en el juego como en el editor
@export var quantity: int = 1:
  set(value):
    if item == null:
      quantity = 0
    else:
      if value > item.max_stack:
        quantity = item.max_stack
      elif value <= 0:
        quantity = 1
      else:
        quantity = value
    _update_label()

var is_open: bool = false

func _ready() -> void:
  _update_texture()
  _update_label()
  if Engine.is_editor_hint():
    return
  interact_area.area_entered.connect( _on_area_enter )
  interact_area.area_exited.connect( _on_area_exit )
  is_open_data.data_loaded.connect( set_chest_state )
  set_chest_state()

func player_interact() -> void:
  if is_open == true:
    return
  if not item:
    return
  is_open = true
  is_open_data.set_value()
  animation_player.play("open_chest")
  PlayerManager.INVENTORY.add_item( item, quantity )

func set_chest_state() -> void:
  is_open = is_open_data.value
  if is_open:
    animation_player.play("opened")
  else:
    animation_player.play("closed")


func _on_area_enter( _a : Area2D ) -> void:
  PlayerManager.interacted.connect( player_interact )

func _on_area_exit( _a : Area2D ) -> void:
  PlayerManager.interacted.disconnect( player_interact )

func _update_texture() -> void:
  if item and sprite:
    sprite.texture = item.texture

func _update_label() -> void:
  if label:
    if quantity <= 1:
      label.text = ""
    else:
      label.text = "x" + str( quantity )

