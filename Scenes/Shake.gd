extends Node
var lifetime : float = 3
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
			var length = randf() * 6 * (3 - lifetime)/3.0
			offset = Vector2(length * cos(angle), length * sin(angle))
			parent.offset += offset
		else:
			queue_free()
