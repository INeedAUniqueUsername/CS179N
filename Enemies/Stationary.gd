extends Node2D

const score = 100

signal on_destroyed
func destroyed():
	emit_signal("on_destroyed", self)
	queue_free()
