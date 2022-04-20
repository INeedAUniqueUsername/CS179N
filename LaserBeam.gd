extends Node2D
var vel = Vector2(0, 0)
export(float) var damp = 1

var dmg = 10

func _physics_process(delta):
	if damp > 0:
		vel -= vel.normalized() * damp * delta
	global_translate(vel * delta)

func _on_Area2D_area_entered(area):
	area.get_parent().get_parent().take_damage(dmg)
	queue_free()
