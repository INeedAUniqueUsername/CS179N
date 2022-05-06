extends Node2D
export(Vector2) var vel = Vector2(0, 0)

export(float) var lifespan = 2.0
export(float) var damage = 25.0
export(float) var damp = 1.0

onready var lifetime = lifespan
var ignore = []
var target

func _physics_process(delta):
	lifetime -= delta
	if lifetime < 0:
		explode()
		return
	if damp > 0:
		vel -= vel.normalized() * min(damp * delta, vel.length())
	if target != null:
		look_at(target.global_position)
	global_translate(vel * delta)
	
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

func explode():
	queue_free()
