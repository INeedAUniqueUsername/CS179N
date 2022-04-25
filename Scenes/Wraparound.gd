extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(PackedScene) var bossType

var radius = 600
onready var diameter = radius * 2
var time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("register_actors")
var player
var leaves = []
var bossSummon = []
func register_actors():
	var d = get_descendants(self)
	for l in d:
		if l.is_in_group("Projectile"):
			continue
		if l.is_in_group("Actor"):
			leaves.append(l)
			
			l.connect("on_destroyed", self, "on_destroyed")
			if l.is_in_group("Player"):
				player = l
			if l.is_in_group("Boss Summon"):
				bossSummon.append(l)
	if player == null:
		pass
		
signal on_boss_summoned
signal on_boss_destroyed
func on_destroyed(n):
	leaves.erase(n)
	if n.is_in_group("Boss Summon"):
		bossSummon.erase(n)
		if len(bossSummon) == 0:
			var b = bossType.instance()
			add_child(b)
			b.connect("on_destroyed", self, "on_boss_destroyed")
			b.global_position = player.global_position + polar2cartesian(600, rand_range(0, PI*2))
			emit_signal("on_boss_summoned", b)
func on_boss_destroyed(boss):
	emit_signal("on_boss_destroyed")
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
