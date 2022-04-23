extends Node
func get_parent_actor(n):
	while n and !n.is_in_group("Actor"):
		n = n.get_parent()
	return n
