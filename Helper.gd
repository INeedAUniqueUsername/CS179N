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
const SpriteFade = preload("res://SpriteFade.tscn")
func create_sprite_fade(container:Node2D, spr : Sprite, time:float = 0.1):	
	var sf = SpriteFade.instance()
	print(container.name)
	sf.texture = spr.texture
	
	sf.centered = spr.centered
	sf.offset = spr.offset
	sf.flip_h = spr.flip_h
	sf.flip_v = spr.flip_v
	
	sf.vframes = spr.vframes
	sf.hframes = spr.hframes
	sf.frame = spr.frame
	sf.frame_coords = spr.frame_coords
	
	sf.region_enabled = spr.region_enabled
	sf.region_rect = spr.region_rect
	container.add_child(sf)
	sf.set_global_transform(spr.get_global_transform())
	sf.get_node("Fade").playback_speed = 1 / time
