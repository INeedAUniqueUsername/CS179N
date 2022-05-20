extends Node2D
export (int) var fuel = 25
export (int) var fuelMax = 5
export (int) var hp = 50
export (int) var hpMax = 10
export (int) var energy = 50
export (int) var energyMax = 10

enum pickups {Fuel, Health, Energy}
export (pickups) var pickupType;

var fueltxt = "+25 Fuel\n+5 Max Fuel"
var hptxt = "+50 HP\n+10 Max HP"
var energytxt = "+50 Energy\n+10 Max Energy"

const pickupLbl = preload("res://Powerups/PickupLabel.tscn")

func _on_Pickup_Area_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		var lbl = pickupLbl.instance()
#		$Pickup.play()
#		yield($Pickup, "finished")
		match pickupType:
			pickups.Fuel:
				actor.add_fuel(fuel, fuelMax)
				lbl.text = fueltxt
			pickups.Health:
				actor.add_hp(hp, hpMax)
				lbl.text = hptxt
			pickups.Energy:
				actor.add_energy(energy, energyMax)
				lbl.text = energytxt
			_:
				print("Error: Invalid Pickup Type")
				
		get_parent().add_child(lbl)
		lbl.rect_global_position = global_position + Vector2(-50, -50)
		queue_free()
