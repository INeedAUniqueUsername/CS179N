extends Node
const ThunderDrone = preload("res://Enemies/ThunderDrone.tscn")
const SpaceCube = preload("res://Enemies/SpaceCube.tscn")
const MineLayer = preload("res://Enemies/MineLayer.tscn")
const LostVector = preload("res://LostVector.tscn")
const StarMachine = preload("res://StarMachine.tscn")

const LaserDrone = preload("res://Enemies/LaserDrone.tscn")
const MissileDrone = preload("res://Enemies/MissileDrone.tscn")
const ShockDrone = preload("res://Enemies/Shock Drone.tscn")
const LightningDrone = preload("res://Enemies/Lightning Drone.tscn")
const ShieldDrone = preload("res://Enemies/Shield Drone.tscn")

const LaserSentry = preload("res://Enemies/LaserSentry.tscn")
const ShieldedLaserSentry = preload("res://Enemies/ShieldedLaserSentry.tscn")

var enemyTables : Array = [
	EnemyTable.new({
		LaserDrone: 60,
		ShockDrone:10, LightningDrone: 5
	}),
	EnemyTable.new({
		LaserDrone: 60,
		LaserSentry:20,
		ShieldedLaserSentry:20,
		MissileDrone: 10,
	}),
	EnemyTable.new({
		LaserDrone:60,
		MissileDrone:30,
		ShieldedLaserSentry:20,
		ShieldDrone:10,
	}),
	EnemyTable.new({
		LaserDrone:60,
		MissileDrone:30,
		ShieldedLaserSentry:20,
		ShieldDrone:10,
	}),
	EnemyTable.new({
		LaserDrone:60,
		MissileDrone:30,
		ShieldedLaserSentry:20,
		ShieldDrone:10,
	})
]
var level_count = 5
var bosses = [
	ThunderDrone,
	SpaceCube,
	MineLayer,
	LostVector,
	StarMachine
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
