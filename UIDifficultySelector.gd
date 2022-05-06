extends Control

signal difficultyChanged(new_difficulty)
onready var difficulty_button: OptionButton = $OptionButton

func _update_selected_difficulty(text: String) -> void:
	emit_signal("difficulty_changed", text)

func _on_OptionButton_toggled(_index: int) -> void:
	 _update_selected_difficulty(difficulty_button.text)
<<<<<<< Updated upstream

func update_settings(settings: Dictionary) -> void:
	OS.window_fullscreen = settings.fullscreen
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, settings.resolution)
	OS.set_window_size(settings.resolution)
	OS.vsync_enabled = settings.vsync

func _on_UIVideoSettings_apply_button_pressed(settings) -> void:
	update_settings(settings)
=======
>>>>>>> Stashed changes
