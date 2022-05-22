extends Node2D

var player
const rx = 480 + 96 * 2
const ry = rx - 96

const dx = rx * 2
const dy = ry * 2

var dark = preload("res://Darkness.tscn")
func _ready():
	var table = {
		0: true,
		1: false,
		2: false,
		3: true,
		4: false
	}
	if !table[PlayerVariables.level]:
		queue_free()
		return
	
	player = get_parent().player
	if !player:
		get_parent().connect("registered_player", self, "registered_player")
	#var r = 48
	var s = 48
	#var ext = radius/s
	for x in range(-rx / s, rx / s):
		for y in range(-ry / s, ry / s):
			var d = dark.instance()
			d.global_position = Vector2(x, y) * s
			call_deferred("add_child", d)
	#var d = dark.instance()
	#d.global_position = Vector2(0, 0)
	#add_child(d)
	
	#for v in [Vector2(-1, -1), Vector2(-1, 0), Vector2(-1, 1), Vector2(0, -1), Vector2(0, 1), Vector2(1, -1), Vector2(1, 0), Vector2(1, 1)]:
	#	d = dark.instance()
	#	d.global_position = r * v * i
	#	add_child(d)
func registered_player(pl):
	player = pl
var time = 0.0
func _process(delta):
	
	time += delta
	if time > 0.25:
		time = 0
		var pl = player.global_position
		for l in get_children():
			var offset = l.global_position - pl
			if offset.x < -rx:
				var inc = ceil(abs(offset.x / dx)) * dx
				l.global_position.x += inc
				offset.x += inc
				#print("Inc: " + inc)
				#offset.x += diameter
				#l.global_position.x += diameter
			if offset.x > rx:
				var inc = ceil(abs(offset.x / dx)) * dx
				l.global_position.x -= inc
				offset.x -= inc
				#offset.x -= diameter
				#l.global_position.x -= diameter
			if offset.y < -ry:
				var inc = ceil(abs(offset.y / dy)) * dy
				l.global_position.y += inc
				offset.y += inc
				#offset.y += diameter
				#l.global_position.y += diameter
			if offset.y > ry:
				var inc = ceil(abs(offset.y / dy)) * dy
				l.global_position.y -= inc
				offset.y -= inc
				#offset.y -= diameter
				#l.global_position.y -= diameter
