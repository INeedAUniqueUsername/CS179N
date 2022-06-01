extends Control
func _process(delta):
	var esc = Input.is_key_pressed(KEY_ESCAPE)
	if esc and !prev_esc:
		prev_esc = esc
		if get_tree().paused:
			unpause()
		else:
			pause()
	else:
		prev_esc = esc		
var prev_esc = false

func toggle():
	if get_tree().paused:
		unpause()
	else:
		pause()
func pause():
	show()
	get_tree().paused = true
func unpause():
	get_tree().paused = false
	hide()
func quit():
	get_tree().paused = false
	get_tree().change_scene("res://Title.tscn")
