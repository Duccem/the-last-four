class_name InventoryUI extends Control

const ITEM_SLOT_SCENE: PackedScene = preload("res://src/GUI/menu/inventory/slot_gui.tscn")

@export var data: Inventory

func _ready() -> void:
  Menu.shown.connect(update_inventory)
  Menu.hidden.connect(clear_inventory)
  clear_inventory()
  pass

func clear_inventory() -> void:
  for child in get_children():
    child.queue_free()

func update_inventory() -> void:
  for item in data.slots:
    var slot_instance: SlotUI = ITEM_SLOT_SCENE.instantiate()
    add_child(slot_instance)
    slot_instance.slot = item
  
  get_child(0).grab_focus()