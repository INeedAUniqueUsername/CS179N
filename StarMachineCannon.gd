extends Sprite


var vel : Vector2 setget set_vel, get_vel
onready var parent : Node2D = get_parent()
func get_vel():
	return parent.vel
func set_vel(vel):
	parent.vel = vel


var beamCooldown = 6
const beamInterval = 6
func _process(delta):
	beamCooldown = max(0, beamCooldown - delta)
	if parent.attackable > 0 and beamCooldown == 0:
		$Anim.play("Fire")
		beamCooldown = beamInterval
signal on_destroyed(Node2D)
var hp = 300
var hp_max = 300
func damage(projectile):
	hp = max(0, hp - projectile.damage)
	if hp == 0:
		destroy()
func destroy():
	emit_signal("on_destroyed", self)
	queue_free()

func _on_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Projectile"):
		if actor.ignore.has(self):
			return
		damage(actor)

const projectile = preload("res://CrescentBlast.tscn")
func fire():
	var b = projectile.instance() as Node2D
	b.ignore = parent.ignore
	b.ignore.append(b)
	parent.get_parent().get_parent().add_child(b)
	b.global_rotation = global_rotation
	b.global_position = $BeamOrigin.global_position
	b.vel = vel + polar2cartesian(720, global_rotation)
