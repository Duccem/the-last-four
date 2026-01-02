@tool
class_name ItemPickup extends CharacterBody2D

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var item: Item: set = _set_item
@export var quantity: int = 1

func _ready() -> void:
  update_texture()
  if Engine.is_editor_hint():
    return
  area_2d.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
  var collision_info = move_and_collide( velocity * delta )
  if collision_info:
    velocity = velocity.bounce(collision_info.get_normal())
  velocity -= velocity * delta * 8

func _set_item(value: Item) -> void:
  item = value
  update_texture()

func update_texture() -> void:
  if item != null and sprite_2d != null:
    sprite_2d.texture = item.texture

func _on_body_entered(body) -> void:
  if body is Player:
    if item != null:
      if PlayerManager.INVENTORY.add_item(item, quantity):
        item_picked_up()

func item_picked_up() -> void:
  area_2d.body_entered.disconnect(_on_body_entered)
  audio_stream_player_2d.play()
  visible = false
  await audio_stream_player_2d.finished
  queue_free()