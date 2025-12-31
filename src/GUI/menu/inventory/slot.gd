class_name Slot extends Resource

@export var item: Item
@export var quantity: int = 0

func is_empty() -> bool:
  return item == null

func can_add(item_to_add: Item, count: int) -> bool:
  if is_empty():
    return true
  if item == item_to_add:
    return quantity + count <= item.max_stack
  return false

func add_item(item_to_add: Item, count: int) -> int:
  if is_empty():
    var to_add = min(count, item_to_add.max_stack)
    item = item_to_add
    quantity = to_add
    return to_add
  elif item == item_to_add:
    var space_left = item.max_stack - quantity
    var to_add = min(count, space_left)
    quantity += to_add
    return to_add
  return 0