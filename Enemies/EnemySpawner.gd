extends Node
var enemyTypes = Levels.enemyTables[PlayerVariables.level]
var extents = 600
onready var actors = get_parent()
const Difficulty = PlayerVariables.DifficultyModes
func _ready():
	call_deferred("generate_initial_wave")
	sources = get_parent().bossSummon
var sources
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
func get_summon_pos():
	if !sources.empty():
		var s = sources[randi() % len(sources)]
		return s.global_position + polar2cartesian(rand_range(120, 360), randf() * PI * 2)
	var b = get_parent().boss
	if b:
		return b.global_position + polar2cartesian(rand_range(120, 360), randf() * PI * 2)
		
		
	var p = get_parent().player
	if p:
		return p.global_position + polar2cartesian(rand_range(120, 360), randf() * PI * 2)
	return Vector2(rand_coord(), rand_coord())
const appear = preload("res://SummonForm.tscn")
var burst = preload("res://SummonFlash.tscn")
func generate_random_enemy():
	if len(actors.leaves) > 16 + 1 + 16:
		return
	if enemyTypes.empty():
		queue_free()
		return
	for i in range(1):
		var pos = get_summon_pos()
		var a = appear.instance()
		a.global_position = pos
		add_child(a)
		yield(a, "tree_exited")
		var type = enemyTypes.pick_random()
		var enemy = type.instance()
		actors.add_child(enemy)
		enemy.global_position = pos
		actors.register(enemy)
		var b = burst.instance()
		actors.add_child(b)
		b.global_position = enemy.global_position
