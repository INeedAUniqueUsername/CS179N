extends Node2D
var vel = Vector2(0, 0)
export(float) var damp = 1

var dmg = 10 setget, get_dmg
func get_dmg(): return dmg

func _physics_process(delta):
	if damp > 0:
		vel -= vel.normalized() * damp * delta
	global_translate(vel * delta)
