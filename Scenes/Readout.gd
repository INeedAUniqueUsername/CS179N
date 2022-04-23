extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("register_player")
func register_player():
	player = get_parent().get_parent().get_node("Actors").player

var player
# Called every frame. 'delta' is the elapsed time since the previous frame.

var width = {
	'hp':0,
	'energy':0,
	'fuel':0
}
var dest_width = {
	'hp':0,
	'energy':0,
	'fuel':0
}
func _process(delta):
	dest_width.hp = int(96 * player.hp / 100)
	dest_width.energy = int(96 * player.energy / 100)
	dest_width.fuel = int(96 * player.fuel / 100)
	
	width.hp += (dest_width.hp - width.hp)/15.0
	width.energy += (dest_width.energy - width.energy)/15.0
	width.fuel += (dest_width.fuel - width.fuel)/15.0
	
	$HealthFront.region_rect.size.x = ceil(width.hp)
	$EnergyFront.region_rect.size.x = ceil(width.energy)
	$FuelFront.region_rect.size.x = ceil(width.fuel)
