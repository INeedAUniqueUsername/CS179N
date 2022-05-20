extends Node2D
export (int) var fuel = 25
export (int) var fuelMax = 5
export (int) var hp = 50
export (int) var hpMax = 10
export (int) var energy = 50
export (int) var energyMax = 10

enum pickups {Fuel, Health, Energy}
export (pickups) var pickupType;

func _on_Pickup_Area_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
#		$Pickup.play()
#		yield($Pickup, "finished")
		
		match pickupType:
			pickups.Fuel:
				actor.add_fuel(fuel, fuelMax)
			pickups.Health:
				actor.add_hp(hp, hpMax)
			pickups.Energy:
				actor.add_energy(energy, energyMax)
			_:
				print("Error: Invalid Pickup Type")
				
		queue_free()
