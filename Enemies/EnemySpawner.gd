extends Node
var rand = RandomNumberGenerator.new()
var enemyTypes = Levels.enemyTables[0]
var extents = 600
onready var actors = get_parent()
func rand_coord():
	return rand_range(-extents, extents)
func _on_random_generation_timer_timeout():
	if enemyTypes.empty():
		queue_free()
		return
	for i in range(1):
		var type = enemyTypes.pick_random()
		var enemy = type.instance()
		actors.add_child(enemy)
		enemy.global_position = Vector2(rand_coord(), rand_coord())
		actors.register(enemy)
