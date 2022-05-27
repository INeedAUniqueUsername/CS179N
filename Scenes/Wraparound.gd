extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(PackedScene) var bossType

var radius = 960
onready var diameter = radius * 2
var time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("register_actors")
	bossType = Levels.bosses[PlayerVariables.level]
var player
var boss
var leaves = []
var bossSummon = []
signal registered_player(Node2D)
func register_actors():
	var d = get_descendants(self)
	for l in d:
		if l.is_in_group("Projectile"):
			continue
		if l.is_in_group("Segment"):
			continue
		if !(l.is_in_group("Actor") or l.is_in_group("Fog")):
			continue
		if leaves.has(l):
			continue
		if !Helper.get_parent_actor(l.get_parent()):
			register(l)
		if l.is_in_group("Player"):
			player = l
		if l.is_in_group("Boss Summon"):
			bossSummon.append(l)
	if player:
		emit_signal("registered_player", player)
func register(a):
	leaves.append(a)
	print('register: ' + a.name)
	a.connect("on_destroyed", self, "on_destroyed")
signal on_boss_summoned
signal on_boss_destroyed
func on_destroyed(n):
	if "score" in n:
		player.common.levelScore += n.score
	leaves.erase(n)
	if n.is_in_group("Boss Summon"):
		bossSummon.erase(n)
		if len(bossSummon) == 0:
			summon_boss()
	elif n == boss:
		emit_signal("on_boss_destroyed")
		
var bossAppeared = false
func summon_boss():
	if bossAppeared:
		return
	bossAppeared = true
	var b = bossType.instance()
	call_deferred("add_child", b)
	b.global_position = player.global_position + polar2cartesian(600, rand_range(0, PI*2))
	for l in get_descendants(b):
		if !l.is_in_group("Actor"):
			continue
		if l.is_in_group("Segment"):
			continue
		register(l)
	emit_signal("on_boss_summoned", b)
func clear_level():
	for c in get_children():
		if c != player:
			c.queue_free()
	leaves.clear()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_key_pressed(KEY_BACKSPACE):
		summon_boss()
		return
	time += delta
	if time > 0.4:
		time = 0
		var pl = player.global_position
		for l in leaves:
			var offset = l.global_position - pl
			if offset.x < -radius:
				var inc = ceil(abs(offset.x / diameter)) * diameter
				l.global_position.x += inc
				offset.x += inc
				#print("Inc: " + inc)
				#offset.x += diameter
				#l.global_position.x += diameter
			if offset.x > radius:
				var inc = ceil(abs(offset.x / diameter)) * diameter
				l.global_position.x -= inc
				offset.x -= inc
				#offset.x -= diameter
				#l.global_position.x -= diameter
			if offset.y < -radius:
				var inc = ceil(abs(offset.y / diameter)) * diameter
				l.global_position.y += inc
				offset.y += inc
				#offset.y += diameter
				#l.global_position.y += diameter
			if offset.y > radius:
				var inc = ceil(abs(offset.y / diameter)) * diameter
				l.global_position.y -= inc
				offset.y -= inc
				#offset.y -= diameter
				#l.global_position.y -= diameter
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
