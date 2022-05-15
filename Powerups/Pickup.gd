extends Node2D
export (int) var hp = 0
export (int) var hpMax = 0
export (int) var energy = 0
export (int) var energyMax = 0
export (int) var fuel = 0
export (int) var fuelMax = 0
func _on_Pickup_Area_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		#to do
		#inc player fuel
		#inc player fuel max
		#inc player energy
		#inc player energy max
		#inc player hp
		#inc player hp max
		actor.add_fuel(fuel)
		queue_free()
