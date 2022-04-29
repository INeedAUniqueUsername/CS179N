extends Node

func _on_random_generation_timer_timeout():
	var rand = RandomNumberGenerator.new()
	var enemyscene = [
		load("res://Enemies/LaserDrone.tscn")
	]
	var screen_size = get_viewport().get_visible_rect().size
	
	var enemy = enemyscene[randi() % enemyscene.size()].instance()
	rand.randomize()		
	var x = rand.randf_range(0, screen_size.x)
	rand.randomize()
	var y = rand.randf_range(0, screen_size.y)
	enemy.position.y = y
	enemy.position.x = x
	add_child(enemy)
