tool
extends Control

signal toggled(is_button_pressed)

export var title := "" setget set_title
onready var label := $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_CheckBox_toggled(button_pressed: bool) -> void:
	emit_signal("toggled", button_pressed)

func set_title(value: String) -> void:
	title = value
	if not label:
		yield(self, "ready")
	label.text = title
