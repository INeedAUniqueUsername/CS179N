extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var radius = 600
onready var diameter = radius * 2
var time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("register_actors")
var player
var leaves
func register_actors():
	leaves = []
	var d = get_descendants(self)
	for l in d:
		if l.is_in_group("Actor"):
			leaves.append(l)
			
			l.connect("on_destroyed", self, "on_destroyed")
			if l.is_in_group("Player"):
				player = l
	if player == null:
		pass
func on_destroyed(n):
	leaves.erase(n)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if time > 0.5:
		time = 0
		var pl = player.global_position
		for l in leaves:
			var offset = l.global_position - pl
			while offset.x < -radius:
				offset.x += diameter
				l.global_position.x += diameter
			while offset.x > radius:
				offset.x -= diameter
				l.global_position.x -= diameter
			while offset.y < -radius:
				offset.y += diameter
				l.global_position.y += diameter
			while offset.y > radius:
				offset.y -= diameter
				l.global_position.y -= diameter
		#to do: iterate through all children and implement wraparound
func get_leaves(n):
	if n.get_child_count() == 0:
		return [n]
	var c = []
	for ch in n.get_children():
		c.append_array(get_leaves(ch))
	return c
func get_descendants(n):
	var c = [n]
	for ch in n.get_children():
		c.append_array(get_descendants(ch))
	return c
