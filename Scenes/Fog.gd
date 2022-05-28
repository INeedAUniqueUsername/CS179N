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
			
			var dist2 = d.global_position.length_squared()
			var radius2 = pow(360.0, 2)
			d.modulate.a = max(0, min(1, dist2 / radius2))
			call_deferred("add_child", d)
