extends Control

var is_paused = false setget set_is_paused

func _unhandled_input(event):
	# event is the user input section
	# esc -> key press toggles pause/unpause
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused 


func set_is_paused(value):
	# value -> bool
	# stores the current state of the game (pause/resume)
	is_paused = value 
	get_tree().paused = is_paused
	visible = is_paused

func _on_ResumeButton_pressed():
	# signal connected to resume button
	# makes pause menu disappear when resume is pressed
	self.is_paused = false


func _on_QuitButton_pressed():
	# signal connected to quit button
	# closes full application on button press
	 get_tree().quit()


func _on_MainMenuButton_pressed():
	# signal connected to MainMenu Button
	# changes scene completely to main menu once more
	# Note: this should also automatically save the last save checkpoint
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
