extends Control
func _ready():
	$BackButton.connect("pressed", self, "back")
func back():
	get_tree().change_scene("res://Title.tscn")
