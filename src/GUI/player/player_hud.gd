extends CanvasLayer

@onready var heart_container: HFlowContainer = $"Control/heart_container"
@export var heart_prefab: PackedScene


var hearts: Array[HeartGUI] = []

func update_hp(_hp: int, _max_hp: int) -> void:
  update_max_hearts(_max_hp)
  for i in _max_hp:
    update_heart(i, _hp)


func update_heart(_index: int, _hp: int) -> void:
  var _value = clampi(_hp - (_index * 2), 0, 2)
  if _index >= 0 and _index < hearts.size():
    hearts[_index].value = _value

func update_max_hearts(_max_hearts: int) -> void:
  var max_hearts_current: int = roundi(float(_max_hearts) / 2.0)
  if hearts.size() >= max_hearts_current:
    return
  while hearts.size() < max_hearts_current:
    var new_heart: HeartGUI = heart_prefab.instantiate() as HeartGUI
    heart_container.add_child(new_heart)
    hearts.append(new_heart)