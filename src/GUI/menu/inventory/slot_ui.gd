class_name SlotUI extends Button

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

var slot: Slot: set = set_slot_data

func _ready():
  texture_rect.texture = null
  label.text = ""
  focus_entered.connect(_on_focus_entered)
  focus_exited.connect(_on_focus_exited)

func set_slot_data(value: Slot) -> void:
  slot = value
  if slot == null:
    return
  texture_rect.texture = slot.item.texture
  label.text = str(slot.quantity)

func _on_focus_entered() -> void:
  if slot == null:
    return
  if slot.item == null:
    return
  Menu.update_item_description(slot.item.description)

func _on_focus_exited() -> void:
  Menu.update_item_description("")