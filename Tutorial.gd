extends Control
func _ready():
	$BackButton.connect("pressed", self, "back")
func back():
	$MenuClickSound.play()
	yield($MenuClickSound, "finished")
	get_tree().change_scene("res://Title.tscn")
