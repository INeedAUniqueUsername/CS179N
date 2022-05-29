extends Control

signal apply_button_pressed(settings)

var _settings := {resolution = Vector2(640, 480), fullscreen = false, vsync = false}

func _on_ApplyButton_toggled() -> void:
	emit_signal("apply_button_pressed", _settings)


func _on_UIResolutionSelector_resolution_changed(new_resolution: Vector2) -> void:
	_settings.resolution = new_resolution
	update_settings(_settings)

func _on_UIFullScreenSelector_toggled(is_button_pressed: bool) -> void:
	_settings.fullscreen = is_button_pressed
	update_settings(_settings)

func _on_UIVSyncCheckbox_toggled(is_button_pressed: bool) -> void:
	_settings.vsync = is_button_pressed
	update_settings(_settings)

func update_settings(settings: Dictionary) -> void:
	OS.window_fullscreen = settings.fullscreen
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, settings.resolution)
	OS.set_window_size(settings.resolution)
	OS.vsync_enabled = settings.vsync

func _on_UIVideoSettings_apply_button_pressed(settings) -> void:
	update_settings(settings)
