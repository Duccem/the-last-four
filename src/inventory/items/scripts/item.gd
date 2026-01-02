class_name Item extends Resource

@export var name: String = ""
@export_multiline var description: String = ""
@export var texture: Texture2D
@export var stackable: bool = true
@export var max_stack: int = 99

@export_category("Item Use Effects")
@export var effects : Array[ ItemEffect ]

func use() -> bool:
	if effects.size() == 0:
		return false

	var can_use = false

	for e in effects:
		if e and e.can_use():
			can_use = true
			break

	if not can_use:
		return false
	
	for e in effects:
		if e:
			e.use()
	return true