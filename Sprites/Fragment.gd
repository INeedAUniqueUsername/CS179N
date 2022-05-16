extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().connect("on_expired", self, "on_expired")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

const projectile = preload("res://Sprites/StarFragment.tscn")
onready var p = get_parent()
var ready = true
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
	if !ready:
		return
	ready = false
	var ignore = p.ignore
	ignore.append(self)
	for i in range(5):
		var angle = i * PI * 2 / 5.0
		var b = projectile.instance()
		b.ignore = ignore
		b.ignore.append(b)
		p.get_parent().add_child(b)
		b.global_position = p.global_position
		b.global_position += polar2cartesian(16, angle)
		b.vel = p.vel + polar2cartesian(360, angle)
