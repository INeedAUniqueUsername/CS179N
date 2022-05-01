extends Camera2D

export(NodePath) var player

# Called when the node enters the scene tree for the first time.
func _ready():
	if player != '':
		player = get_node(player)
	else:
		call_deferred("register_player")
func register_player():
	player = get_parent().get_node("Actors").player
	player.common.connect("on_destroyed", self, "on_player_destroyed")
func on_player_destroyed(pl):
	player = null
func _physics_process(delta):
	#rotation_degrees = player.rotation_degrees
	if player:
		position = player.position - player.vel / 120
func shake():
	pass
