extends Node
const fragment = preload("res://Sprites/MineLayerSpikeFragment.tscn")
onready var parent = get_parent()
signal on_fragmented
var warmup = 1
func _ready():
	parent.connect("on_destroyed", self, "on_destroyed")
var targets = []
func _process(delta):
	if warmup > 0:
		warmup -= delta
	elif !targets.empty():
		fragment()
		targets.clear()
func on_destroyed(p):
	if warmup > 0:
		return
	fragment()
func fragment():
	var count = 16
	var speed = 240
	for i in range(count):
		var angle = i * PI * 2 / count
		Helper.create_projectile(fragment, parent.get_parent(), parent.ignore,
			parent.global_position,
			parent.vel + polar2cartesian(speed, angle),
			angle)
	emit_signal("on_fragmented")
	queue_free()
func _on_TriggerArea_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if parent.ignore.has(actor):
		return
	if actor and actor.is_in_group("Player"):
		if warmup > 0:
			targets.append(actor)
			return
		fragment()


func _on_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if parent.ignore.has(actor):
		return
	if actor and actor.is_in_group("Projectile"):
		if warmup > 0:
			return
		fragment()
func _on_TriggerArea_exited(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if parent.ignore.has(actor):
		return
	if actor and actor.is_in_group("Projectile"):
		targets.erase(actor)
