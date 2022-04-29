extends Node

func get_parent_actor(n):
	while n and !n.is_in_group("Actor"):
		n = n.get_parent()
	return n
func is_area_body(area):
	if area.is_in_group("Behavior"):
		return false
	if area.is_in_group("Damage"):
		return false
	return true
