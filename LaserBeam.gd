extends Node2D
var vel = Vector2(0, 0)
export(float) var damp = 1
export(float) var knockback = 3
export(int) var pierce = 5
var dmg = 10 setget, get_dmg
func get_dmg(): return dmg

var ignore = []
func _physics_process(delta):
	if damp > 0:
		vel -= vel.normalized() * damp * delta
	global_translate(vel * delta)
func _on_area_entered(area):
	if area.is_in_group("Behavior"):
		return
	if area.is_in_group("Damage"):
		return
	var actor = Helper.get_parent_actor(area)
	if ignore.has(actor):
		return
	if actor:
		pierce -= 1
		actor.vel += vel.normalized() * knockback
		var n = actor.name
		if pierce < 1:
			queue_free()
