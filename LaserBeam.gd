extends Node2D
export(Vector2) var vel = Vector2(0, 0)

export(float) var lifespan = 1.0
export(float) var damage = 25.0
export(float) var drain = 0
export(int) var pierce = 1
export(float) var damp = 0
export(float) var knockback = 3.0
export(NodePath) var trail = null
func _ready():
	if trail:
		trail = get_node(trail)

var time_scale = 1
func set_time_scale(t):
	time_scale = t

onready var lifetime = lifespan
var ignore = []
const SpriteFade = preload("res://SpriteFade.tscn")
var trailTime = 0
signal on_expired(Node2D)
signal on_destroyed(Node2D)
func _physics_process(delta):
	delta *= time_scale
	lifetime -= delta
	if lifetime < 0:
		emit_signal("on_expired", self)
		destroy()
		return
	if trail:
		trailTime -= delta
		if trailTime < 0:
			trailTime = 1 / 90.0
			Helper.create_sprite_fade(get_parent(), trail, 0.1 / time_scale)
	if damp > 0:
		vel -= vel.normalized() * min(damp * delta, vel.length())
	elif damp < 0:
		vel += polar2cartesian(damp * delta, rotation)
	global_translate(vel * delta)
func _on_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if ignore.has(actor):
		return
	if !actor:
		return
	if actor.is_in_group("Projectile"):
		return
	pierce -= 1
	if !actor.is_in_group("Stationary"):
		var mass = 1.0
		if 'mass' in actor:
			mass *= actor.mass
		actor.vel += vel.normalized() * knockback / mass
	var s = self.name
	var n = actor.name
	actor.damage(self)
	if pierce < 1:
		destroy()
func damage(projectile):
	var actor = Helper.get_parent_actor(projectile)
func destroy():
	emit_signal("on_destroyed", self)
	queue_free()
