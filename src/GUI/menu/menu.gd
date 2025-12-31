extends CanvasLayer

signal shown
signal hidden

@onready var save_button: Button = $wrap/Container/ButtonSave
@onready var load_button: Button = $wrap/Container/ButtonLoad
@onready var exit_button: Button = $wrap/Container/ButtonExit
@onready var item_description: Label = $wrap/ItemDescription
@onready var audio_stream_player: AudioStreamPlayer = $wrap/AudioStreamPlayer

var is_paused: bool = false

func _ready() -> void:
	save_button.pressed.connect(_on_save_button_pressed)
	load_button.pressed.connect(_on_load_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)
	hide_menu()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if is_paused:
			hide_menu()
		else:
			show_menu()
		get_viewport().set_input_as_handled()

func show_menu() -> void:
	visible = true
	is_paused = true
	get_tree().paused = true
	shown.emit()

func hide_menu() -> void:
	visible = false
	is_paused = false
	get_tree().paused = false
	hidden.emit()

func _on_save_button_pressed() -> void:
	if not is_paused:
		return
	SaveManager.save_game()
	hide_menu()

func _on_load_button_pressed() -> void:
	if not is_paused:
		return
	SaveManager.load_game()
	await LevelManager.level_load_started
	hide_menu()

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func update_item_description(text: String) -> void:
	item_description.text = text

func play_audio( audio : AudioStream ) -> void:
	audio_stream_player.stream = audio
	audio_stream_player.play()

func item_focused_changed(slot: Slot) -> void:
	if slot == null or slot.item == null:
		update_item_description("")
	else:
		update_item_description(slot.item.description)