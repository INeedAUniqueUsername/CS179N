extends Node
var enemyTypes = Levels.enemyTables[PlayerVariables.level]
var extents = 600
onready var actors = get_parent()
const Difficulty = PlayerVariables.DifficultyModes
func _ready():
	call_deferred("generate_initial_wave")
func generate_initial_wave():
	var table = {
		Difficulty.Easy: 0,
		Difficulty.Medium:4,
		Difficulty.Hard:8
	}
	for i in range(table[PlayerVariables.difficulty]):
		generate_random_enemy()
func rand_coord():
	return rand_range(-extents, extents)
func generate_random_enemy():
	if len(actors.leaves) > 16 + 1 + 16:
		return
	
	if enemyTypes.empty():
		queue_free()
		return
	for i in range(1):
		var type = enemyTypes.pick_random()
		var enemy = type.instance()
		actors.add_child(enemy)
		enemy.global_position = Vector2(rand_coord(), rand_coord())
		actors.register(enemy)
