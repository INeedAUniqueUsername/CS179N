extends Node
enum HeroTypes {
	asteria,
	astroknight,
	lune,
	starman
}
var records = {
	DifficultyModes.Easy: {
		HeroTypes.starman: false,
		HeroTypes.asteria: false,
		HeroTypes.astroknight: false,
		HeroTypes.lune: false
	},
	DifficultyModes.Medium: {
		HeroTypes.starman: false,
		HeroTypes.asteria: false,
		HeroTypes.astroknight: false,
		HeroTypes.lune: false
	},
	DifficultyModes.Hard: {
		HeroTypes.starman: false,
		HeroTypes.asteria: false,
		HeroTypes.astroknight: false,
		HeroTypes.lune: false
	}
}
var bossesMet = {
	"Thunder Drone": false,
	"Space Cube & Time Pilot": false,
	"Mine Layer": false,
	"Rawbawjaw": false,
	"Star Machine": false
}

func desc(heroName, primary, secondary):
	return "%s\n\n[X] %s\n[Z] %s" % [heroName, primary, secondary]
var heroDesc = {
	HeroTypes.starman: desc("Starman", "Laser Cannons", "Shooting Star"),
	HeroTypes.asteria: desc("Asteria", "Plasma Thrower", "Star Burst"),
	HeroTypes.astroknight: desc("Astroknight", "Steel Bolt", "Solar Saber"),
	HeroTypes.lune: desc("Lune", "Crescent Beam", "Moon Blast")
}

var hero = HeroTypes.starman
func setHero(h):
	hero = h
func set_winner(w):
	winner = w
var winner = true
var totalScore = 0
var totalTime = 0
var level = 0
func set_level(level):
	self.level = level
func inc_level():
	level += 1
	return level < 5
func reset():
	level = 0
	winner = true
	totalScore = 0
	totalTime = 0

enum DifficultyModes {
	Easy, Medium, Hard
}
var difficulty = DifficultyModes.Medium

func _ready():
	var score_data = {}
	var config = ConfigFile.new()

	# If the file didn't load, ignore it.
	if config.load("user://stats.cfg") != OK:
		return
	records = JSON.parse(config.get_value("player", "records")).result
	#convert string keys back to int keys
	for i in records.keys():
		var entry = records[i]
		for j in entry.keys():
			entry[int(j)] = entry[j]
			entry.erase(j)
		records[int(i)] = entry
		records.erase(i)
	bossesMet = JSON.parse(config.get_value("player", "bossesMet")).result
func save():
	var config = ConfigFile.new()
	config.set_value("player", "records", JSON.print(records))
	config.set_value("player", "bossesMet", JSON.print(bossesMet))
	config.save("user://stats.cfg")
