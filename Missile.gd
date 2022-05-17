extends Node2D
export(Vector2) var vel = Vector2(0, 0)

export(float) var lifespan = 2.0
export(float) var damage = 25.0

var beamSpeed = 250

onready var lifetime = lifespan
var ignore = []
var target

var rotationMatchesVel : bool = true
func _physics_process(delta):
	lifetime -= delta
	if lifetime < 0:
		explode()
		return
	if target:
		var offset = (target.global_position - global_position)
		var targetAngle = atan2(offset.y, offset.x)
		var angleDiff = atan2(sin(targetAngle - rotation), cos(targetAngle - rotation))
		var turnRate = PI * 2 / 3
		vel = vel.rotated(sign(angleDiff) * min(abs(angleDiff), delta * turnRate))
	if rotationMatchesVel:
		rotation = atan2(vel.y, vel.x)
	global_translate(vel * delta)
	
var forward = Vector2(0, 0)
func _process(delta):
	forward = get_global_transform().orthonormalized().x
	
func _on_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if !actor:
		return
	if ignore.has(actor):
		return
	if actor.is_in_group("Projectile"):
		explode()
		return
	actor.damage(self)
	explode()

func damage(projectile):
	explode()

signal on_destroyed(Node2D)
const explosion = preload("res://MissileExplosion.tscn")
func explode():
	var explosion_load = explosion.instance()
	explosion_load.ignore = [ignore, explosion_load]
	get_parent().add_child(explosion_load)
	explosion_load.set_global_position(get_global_position())
	explosion_load.playing = true
	emit_signal("on_destroyed", self)
	queue_free()
