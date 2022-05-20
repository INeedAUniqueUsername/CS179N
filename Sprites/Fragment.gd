extends Node
export(bool) var armed = true
func _ready():
	if !armed:
		queue_free()
		return
	get_parent().connect("on_expired", self, "on_expired")
const projectile = preload("res://Sprites/StarFragment.tscn")
onready var p = get_parent()

func on_expired(p):
	fragment()
func _on_FragmentArea_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if p.ignore.has(actor):
		return
	if actor and actor.is_in_group("Actor"):
		fragment()
		p.queue_free()
		return
func fragment():
	if !armed:
		return
	armed = false
	var ignore = p.ignore
	ignore.append(self)
	var c = 3.0
	for i in range(c):
		var angle = i * PI * 2 / c
		var b = projectile.instance()
		b.ignore = ignore
		b.ignore.append(b)
		p.get_parent().call_deferred("add_child", b)
		b.global_position = p.global_position
		b.global_position += polar2cartesian(16, angle)
		b.vel = p.vel + polar2cartesian(360, angle)
