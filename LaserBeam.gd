extends Node2D
export(Vector2) var vel = Vector2(0, 0)

export(float) var lifespan = 1.0
export(float) var damage = 25.0
export(int) var pierce = 1
export(float) var damp = 1.0
export(float) var knockback = 3.0

var time_scale = 1
func set_time_scale(t):
	time_scale = t

onready var lifetime = lifespan
var ignore = []
func _physics_process(delta):
	delta *= time_scale
	lifetime -= delta
	if lifetime < 0:
		queue_free()
		return
	if damp > 0:
		vel -= vel.normalized() * damp * delta
	global_translate(vel * delta)
func _on_area_entered(area):
	if area.is_in_group("Behavior"):
		return
	if area.is_in_group("Damage"):
		return
	var actor = Helper.get_parent_actor(area)
	if !actor:
		return
	if actor.is_in_group("Projectile"):
		return
	if ignore.has(actor):
		return
	pierce -= 1
	if !actor.is_in_group("Stationary"):
		actor.vel += vel.normalized() * knockback
	var s = self.name
	var n = actor.name
	actor.damage(self)
	if pierce < 1:
		queue_free()
func damage(projectile):
	var actor = Helper.get_parent_actor(projectile)
