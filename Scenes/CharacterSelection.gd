extends Node2D

#var asteriaScene = preload("res://Characters/Asteria.tscn").instance()
#var astroknightScene = preload("res://Characters/Astroknight.tscn").instance()
#var luneScene = preload("res://Characters/Lune.tscn").instance()
#var starmanScene = preload("res://Characters/Starman.tscn").instance()

#Actors/Player


# Called when the node enters the scene tree for the first time.
func _ready():
	for button in [$VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/button_char1, $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/button_char2, $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/button_char3, $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/button_char4]:
		button.connect("button_pressed", self, "_on_Button_pressed", [button])
		
func _on_Button_pressed(button : Button):
	#Create global variable -> selected_character -> indicates whith character being selected
	"""
	0 -> Asteria
	1 -> AstroKnight
	2 -> Lune
	3 -> Starman
	"""
	#GlobalVariable.selected_character(0)
	character_choice = $Button.text
	get_tree().change_scene("")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
