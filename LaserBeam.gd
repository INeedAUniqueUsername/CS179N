extends Node2D
var vel = Vector2(0, 0)
func _physics_process(delta):
	global_translate(vel * delta)
