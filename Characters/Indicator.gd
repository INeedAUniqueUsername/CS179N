extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if !OS.is_debug_build():
		queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
const pointer = preload("res://Pointer.tscn")
var nearby = {}
func _process(delta):
	for beacon in nearby.keys():
		var p = nearby[beacon]
		var off = beacon.global_position - global_position
		if off.length() > 240:
			p.global_position = global_position + off.normalized() * min(off.length() / 2, 60)
			p.global_rotation = atan2(off.y, off.x)
			p.modulate.a = 0.5
		else:
			p.modulate.a = 0
func can_track(actor):
	return actor.is_in_group("Boss Summon") or actor.is_in_group("Boss")
func _on_area_entered(area):
	var actor = Helper.get_actor_of_body(area)
	if actor and can_track(actor) and !nearby.keys().has(actor):
		var p = pointer.instance()
		nearby[actor] = p
		add_child(p)
func _on_area_exited(area):
	var actor = Helper.get_actor_of_body(area)
	if actor and can_track(actor) and nearby.keys().has(actor):
		nearby[actor].queue_free()
		nearby.erase(actor)
