extends Node2D
signal on_destroyed
export(String) var bossName
onready var player = get_parent().player
var actors = []
var hp_max_dead = 0
var hp setget, get_hp
var hp_max setget, get_max_hp

func get_hp():
	var hp = 0
	for a in actors:
		hp += a.hp
	return hp
func get_max_hp():
	var hp_max = hp_max_dead
	for a in actors:
		hp_max += a.hp_max
	return hp_max
func _ready():
	for c in get_descendants(self):
		if c.is_in_group("Actor"):
			register(c)
func register(c):
	actors.append(c)
	c.connect("on_destroyed", self, "on_actor_destroyed")
func on_actor_destroyed(a):
	actors.erase(a)
	hp_max_dead += a.hp_max
	if actors.empty():
		emit_signal("on_destroyed", self)
func get_descendants(n):
	var c = [n]
	for ch in n.get_children():
		c.append_array(get_descendants(ch))
	return c
