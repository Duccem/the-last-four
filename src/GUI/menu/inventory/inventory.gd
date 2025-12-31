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
  for slot in slots:
    if slot:
      if slot.is_empty():
        var added = slot.add_item(item, count)
        count -= added
        if count <= 0:
          return true
  
  return false