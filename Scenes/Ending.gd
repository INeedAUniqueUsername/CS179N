extends Control
func get_fate():
	if PlayerVariables.winner:
		return "Escaped the Anomalous Zone"
	else:
		return "Destroyed"
func _ready():
	$Stats.text %= [get_fate(), PlayerVariables.totalTime, PlayerVariables.totalScore]
	$Button.connect("pressed", self, "go_title_screen")
	pass # Replace with function body.
func go_title_screen():
	get_tree().change_scene("res://Title.tscn")
