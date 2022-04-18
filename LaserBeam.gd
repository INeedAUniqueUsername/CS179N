extends Node2D
var vel = Vector2(0, 0)
export(float) var damp = 1
func _physics_process(delta):
	if damp > 0:
		vel -= vel * damp
	global_translate(vel * delta)
