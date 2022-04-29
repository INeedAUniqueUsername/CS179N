extends Node2D

var selected_menu = 0

func _ready():
	changeMenuColor()

func changeMenuColor():
	$Play.color = Color.gray
	$Resume.color = Color.gray
	$Quit.color = Color.gray
	
	match selected_menu:
		0:
			$Play.color = Color.greenyellow
		1:
			$Resume.color = Color.greenyellow
		2:
			$Quit.color = Color.greenyellow
	
func _input(event):
	if Input.is_action_just_pressed("ui_down"):
		selected_menu = (selected_menu + 1) % 3
		changeMenuColor()
	elif Input.is_action_just_pressed("ui_up"):
		if selected_menu> 0:
			selected_menu = selected_menu - 1
		else:
			selected_menu = 2
		changeMenuColor()
	elif Input.is_action_just_pressed("ui_accept"):
		match selected_menu:
			0: # New Game
				get_tree().change_scene("res://Scenes/CharacterSelection.tscn")
			1: # Load game
				# implement Load Game later
				print("INITIALIZE LATER")
			2:
				get_tree().quit()
