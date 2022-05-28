tool
extends Control

signal toggled(is_button_pressed)

onready var label := $label

func _ready():
	pass # Replace with function body.

func set_title():
	pass
	
func _on_CheckBox_toggled(button_pressed: bool) -> void:
	emit_signal("toggled", button_pressed)
