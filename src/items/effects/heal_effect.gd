class_name HealEffect extends ItemEffect

@export var heal_amount: int = 2
@export var audio_heal: AudioStream

func use() -> void:
  PlayerManager.player.update_hp(heal_amount)
  Menu.play_audio(audio_heal)

func can_use() -> bool:
  return PlayerManager.player.health_points < PlayerManager.player.max_health_points