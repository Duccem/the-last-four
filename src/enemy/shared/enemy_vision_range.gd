class_name EnemyVisionRange extends EnemyRange

func rotate_vision(new_direction: Vector2) -> void:
  if new_direction == Vector2.ZERO:
    return
  rotation = new_direction.angle() - PI / 2

func setup() -> void:
  enemy.changed_direction.connect(rotate_vision)