extends Label

export (int) var time = 3
var curr_time = time

func _physics_process(delta):
	curr_time -= delta
	if(curr_time < 1):
		modulate.a -= delta
	if(time < 0):
		queue_free()
