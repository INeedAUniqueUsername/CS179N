extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("register_player")
func register_player():
	player = get_parent().get_parent().get_node("Actors").player

var player
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HealthFront.region_rect.size.x = int(96 * player.hp / 100)
	$EnergyFront.region_rect.size.x = int(96 * player.energy / 100)
	$FuelFront.region_rect.size.x = int(96 * player.fuel / 100)
