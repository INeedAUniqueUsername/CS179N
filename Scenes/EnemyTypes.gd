extends Node
const LaserDrone = preload("res://Enemies/LaserDrone.tscn")
const ThunderDrone = preload("res://Enemies/ThunderDrone.tscn")
const SpaceCube = preload("res://Enemies/SpaceCube.tscn")
var enemyTables : Array = [
	EnemyTable.new({LaserDrone: 30}),
	EnemyTable.new({LaserDrone: 60, ThunderDrone:1}),
]
var level_count = 5
var bosses = [
	ThunderDrone,
	SpaceCube
]

class EnemyTable:
	var table
	func _init(table):
		self.table = table
	func empty():
		return len(table.keys()) == 0
	func pick_random():
		var keys = table.keys()
		var entry = keys[randi()%len(keys)]
		table[entry] -= 1
		if table[entry] < 1:
			table.erase(entry)
		return entry
	
func _ready():
	print(enemyTables)
func table(obj):
	var a = []
	for type in obj.keys():
		var count = obj[type]
		for i in range(count):
			a.append(type)
	return a
