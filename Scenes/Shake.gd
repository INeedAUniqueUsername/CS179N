extends Node
var lifetime : float = 3.0
var max_lifetime : float = 3.0
func set_lifetime(l):
	lifetime = l
	max_lifetime = l
var time : float
const interval : float = 0.05
onready var parent : Camera2D = get_parent()
var offset: Vector2
func _process(delta):
	time += delta
	if time > interval:
		lifetime -= time
		time = 0
		parent.offset -= offset
		if lifetime > 0:
			var angle = randf() * PI * 2
			var length = randf() * 6 * (max_lifetime - lifetime)/max_lifetime
			offset = Vector2(length * cos(angle), length * sin(angle))
			parent.offset += offset
		else:
			queue_free()
