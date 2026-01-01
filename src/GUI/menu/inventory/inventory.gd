class_name Inventory extends Resource

@export var slots: Array[Slot] = []

func add_item(item: Item, count: int = 1) -> bool:
  for slot in slots:
    if slot:
      if slot.item == item:
        if slot.can_add(item, count):
          var added = slot.add_item(item, count)
          count -= added
          if count <= 0:
            return true
  for i in slots.size():
    if slots[i] == null:
      var new_slot = Slot.new()
      var added = new_slot.add_item(item, count)
      slots[i] = new_slot
      count -= added
      if count <= 0:
        return true
        
  return false

func inventory_to_primitives() -> Array:
  var result: Array = []
  for index in slots.size():
    result.append(slot_to_primitives(slots[index]))
  return result

func slot_to_primitives(slot: Slot) -> Dictionary:
  var result = { item = "", quantity = 0 }
  if !slot or !slot.item:
    return result
  result.item = slot.item.resource_path
  result.quantity = slot.quantity
  return result

func inventory_from_primitives(data: Array) -> void:
  slots.clear()
  slots.resize(data.size())
  for index in data.size():
    slots[index] = primitives_to_slot(data[index])

func primitives_to_slot(data: Dictionary) -> Slot:
  var slot = Slot.new()
  if data.item == "":
    return null
  slot.item = load(data.item) as Item
  slot.quantity = int(data.quantity)
  return slot