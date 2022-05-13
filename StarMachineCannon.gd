extends Sprite


var vel : Vector2 setget set_vel, get_vel
onready var parent : Node2D = get_parent()
func get_vel():
	return parent.vel
func set_vel(vel):
	parent.vel = vel

signal on_destroyed(Node2D)
var hp = 300
var hp_max = 300
func damage(projectile):
	hp = max(0, hp - projectile.damage)
	if hp == 0:
		destroy()
func destroy():
	emit_signal("on_destroyed", self)

const projectile = preload("res://CrescentBlast.tscn")
func fire():
	
		var b = projectile.instance() as Node2D
		b.ignore = parent.ignore
		b.ignore.append(b)
		parent.get_parent().get_parent().add_child(b)
		b.global_rotation = global_rotation
		b.global_position = $BeamOrigin.global_position
		b.vel = vel + polar2cartesian(720, global_rotation)
