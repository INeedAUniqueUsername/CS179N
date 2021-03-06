extends Control
func _ready():
	var text
	if PlayerVariables.winner:
		var entry = PlayerVariables.records[PlayerVariables.difficulty][PlayerVariables.hero]
		if !entry:
			entry = {
				'clears': 0,
				'highScore': 0,
				'bestTime': INF
			}
		PlayerVariables.records[PlayerVariables.difficulty][PlayerVariables.hero] = {
			'clears': entry.clears + 1,
			'highScore': max(entry.highScore, PlayerVariables.totalScore),
			'bestTime': min(entry.bestTime, PlayerVariables.totalTime)
		}
		PlayerVariables.save()
		
		text = "Escaped the Anomalous Zone"
		
	else:
		text = "Destroyed"
	$Stats.text %= [text, PlayerVariables.totalTime, PlayerVariables.totalScore]
	$Button.connect("pressed", self, "go_title_screen")
	pass # Replace with function body.
func go_title_screen():
	get_tree().change_scene("res://Title.tscn")
