extends CanvasLayer

@onready var anim_player: AnimationPlayer = $Control/AnimationPlayer

func fade_out() -> bool:
	anim_player.play("fade_out")
	await anim_player.animation_finished
	return true

func fade_in() -> bool:
	anim_player.play("fade_in")
	await anim_player.animation_finished
	return true