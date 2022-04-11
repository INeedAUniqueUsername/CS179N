extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

onready var player = get_parent().get_parent().get_node("Actors/Player")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HealthFront.region_rect.size.x = int(96 * player.hp / 100)
	$EnergyFront.region_rect.size.x = int(96 * player.energy / 100)
