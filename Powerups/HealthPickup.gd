extends Node2D

export (int) var hp = 20

func _on_Pickup_Area_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		$Pickup.play()
		yield($Pickup, "finished")
		actor.add_hp(hp)
		queue_free()
