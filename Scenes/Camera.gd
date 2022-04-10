extends Camera2D

export(NodePath) var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player)
func _physics_process(delta):
	#rotation_degrees = player.rotation_degrees
	position = player.position - player.vel / 120
