class_name EnemyDeathState extends EnemyState

const PICKUP = preload("res://src/inventory/items/scenes/item_pickup.tscn")

@export_category("Item Drops")
@export var drops : Array[ Drop ]

@export_category("animation")
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0

func enter() -> void:
  enemy.velocity = enemy.direction * -knockback_speed
  _drop_items()
  enemy.anim_state.travel("death")
  enemy.anim_tree.animation_finished.connect(_on_animation_finished)

func process(_delta: float) -> EnemyState:
  enemy.velocity -= enemy.velocity * decelerate_speed * _delta
  return null

func _on_animation_finished(_anim_name: StringName) -> void:
  enemy.queue_free()
  
func _drop_items() -> void:
  if drops.size() == 0:
    return
  for index in drops.size():
    if drops[index] == null or drops[index].item == null:
      continue
    var drop_count: int = drops[index].get_drop_count()
    for i in drop_count:
      var drop : ItemPickup = PICKUP.instantiate() as ItemPickup
      drop.item = drops[ i ].item
      enemy.get_parent().call_deferred( "add_child", drop )
      drop.global_position = enemy.global_position
      drop.velocity = enemy.velocity.rotated( randf_range( -1.5, 1.5 ) )