extends Node
const ThunderDrone = preload("res://Enemies/ThunderDrone.tscn")
const SpaceCube = preload("res://Enemies/SpaceCubeAndTimePilot.tscn")
const MineLayer = preload("res://Enemies/MineLayer.tscn")
const LostVector = preload("res://LostVector.tscn")
const StarMachine = preload("res://StarMachine.tscn")

const LaserDrone = preload("res://Enemies/LaserDrone.tscn")

const MissileDrone = preload("res://Enemies/MissileDrone.tscn")
const ShieldedMissileDrone = preload("res://Enemies/ShieldedMissileDrone.tscn")

const ShockDrone = preload("res://Enemies/Shock Drone.tscn")
const LightningDrone = preload("res://Enemies/Lightning Drone.tscn")

const ShieldDrone = preload("res://Enemies/Shield Drone.tscn")

const JunkDrone = preload("res://Enemies/JunkDrone.tscn")

const LaserSentry = preload("res://Enemies/LaserSentry.tscn")
const ShieldedLaserSentry = preload("res://Enemies/ShieldedLaserSentry.tscn")
const MissileSentry = preload("res://Enemies/MissileSentry.tscn")
const ShieldedMissileSentry = preload("res://Enemies/ShieldedMissileSentry.tscn")

var enemyTables : Array = [
	EnemyTable.new({
		LaserDrone: 	90,
		LaserSentry:	30,
		ShockDrone:		10,
		LightningDrone:	5
	}),
	EnemyTable.new({
		LaserSentry:	90,
		ShieldedLaserSentry:30,
		MissileDrone: 		30,
		MissileSentry: 		10,
	}),
	EnemyTable.new({
		LaserSentry:90,
		ShieldedLaserSentry:30,
		ShieldedMissileSentry: 30,
		JunkDrone: 30,
		ShieldDrone:10,
		
	}),
	EnemyTable.new({
		LaserDrone:90,
		MissileDrone:30,
		ShieldedLaserSentry:20,
		ShieldDrone:10,
	}),
	EnemyTable.new({
		LaserDrone:90,
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
