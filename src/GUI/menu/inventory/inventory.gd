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