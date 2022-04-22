extends MarginContainer

const characterSelect = preload("res://Scenes/CharacterSelect.tscn")
#const playGame = preload("")

onready var selector_one = $MainMenu/CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/Label
onready var selector_two =  $MainMenu/CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer2/Selector2
onready var selector_three = $MainMenu/CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer3/HBoxContainer3/Selector3

var current_selection = 0

func _ready():
	set_current_selection(0)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_down") and current_selection > 2:
		current_selection += 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_down") and current_selection > 0:
		current_selection -= 1
		set_current_selection(current_selection)
	elif Input.is_action_just_pressed("ui_accept"):
		handle_selection(current_selection)
		
func handle_selection(_current_selection):
	if _current_selection == 0:
		get_parent().add_child(characterSelect.instance())
		queue_free()
	elif _current_selection == 1:
		print("OPTIONS")
	elif _current_selection == 2:
		get_tree().quit()

func set_current_selection(_current_selection):
	selector_one.text = ""
	selector_two.text = ""
	selector_three.text = ""
	if _current_selection == 0:
		selector_one.text=">"
	elif _current_selection == 0:
		selector_two.text=">"
	elif _current_selection == 0:
		selector_three.text=">"
