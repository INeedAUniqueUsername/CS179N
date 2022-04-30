extends Node


enum HeroTypes {
	asteria,
	astroknight,
	lune,
	starman
}

func desc(heroName, primary, secondary):
	return heroName + "\n\n" + "[X] " + primary + "\n" + "[Z] " + secondary
var heroDesc = {
	HeroTypes.starman: desc("Starman", "Laser Cannons", "Shooting Star"),
	HeroTypes.asteria: desc("Asteria", "Plasma Thrower", "Star Burst"),
	HeroTypes.astroknight: desc("Astroknight", "Blade Beam", "Solar Saber"),
	HeroTypes.lune: desc("Lune", "Crescent Beam", "Moon Blast")
}

var hero
func setHero(h):
	hero = h
func _ready():
	hero = HeroTypes.starman
