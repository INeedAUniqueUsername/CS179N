extends Node2D
export(Vector2) var vel = Vector2(0, 0)

export(float) var lifespan = 2.0
export(float) var damage = 25.0

var beamSpeed = 250

onready var lifetime = lifespan
var ignore = []
var target

func _physics_process(delta):
	lifetime -= delta
	if lifetime < 0:
		explode()
		return
	vel = forward * beamSpeed
	if target != null:
		look_at(target.global_position)
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
	if actor.is_in_group("Projectile"):
		return
	if ignore.has(actor):
		return
	actor.damage(self)
	explode()

const explosion = preload("res://MissileExplosion.tscn")
func explode():
	var explosion_load = explosion.instance()
	explosion_load.ignore = [ignore, explosion_load]
	get_parent().add_child(explosion_load)
	explosion_load.set_global_position(get_global_position())
	explosion_load.playing = true
	queue_free()
