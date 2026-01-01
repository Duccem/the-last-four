class_name InventoryUI extends Control

const ITEM_SLOT_SCENE: PackedScene = preload("res://src/GUI/menu/inventory/slot_gui.tscn")

@export var data: Inventory

func _ready() -> void:
  Menu.shown.connect(update_inventory)
  Menu.hidden.connect(clear_inventory)
  clear_inventory()

func clear_inventory() -> void:
  for child in get_children():
    child.set_slot_data(null)

func update_inventory() -> void:
  clear_inventory()
  for index in data.slots.size():
    var slot: Slot = data.slots[index]
    var slot_ui: SlotUI = get_child(index) as SlotUI
    slot_ui.set_slot_data(slot)
  
  get_child(0).grab_focus()