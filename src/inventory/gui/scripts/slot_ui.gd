class_name SlotUI extends Button

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

var slot: Slot: set = set_slot_data

func _ready():
  texture_rect.texture = null
  label.text = ""
  focus_entered.connect(_on_focus_entered)
  focus_exited.connect(_on_focus_exited)
  pressed.connect(_on_item_pressed)

func set_slot_data(value: Slot) -> void:
  slot = value
  if slot == null:
    return
  texture_rect.texture = slot.item.texture
  label.text = str(slot.quantity)

func _on_focus_entered() -> void:
  Menu.item_focused_changed(slot)

func _on_focus_exited() -> void:
  Menu.update_item_description("")

func _on_item_pressed() -> void:
  use_item()

func use_item() -> void:
  if slot == null:
    return
  if slot.item == null:
    return
  var used = slot.item.use()
  if used:
    slot.remove_item(1)
  if slot.is_empty():
    slot = null
    texture_rect.texture = null
    label.text = ""
    Menu.item_focused_changed(null)
  else:
    label.text = str(slot.quantity)
