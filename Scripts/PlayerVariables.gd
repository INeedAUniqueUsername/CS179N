extends Node


var asteria = preload("res://Characters/Asteria.tscn").instance()
var astroknight = preload("res://Characters/Astroknight.tscn").instance()
var lune = preload("res://Characters/Lune.tscn").instance()
var starman = preload("res://Characters/Starman.tscn").instance()

onready var selected_hero

enum HeroTypes {
	asteria,
	astroknight,
	lune,
	starman
}
var hero
func setHero(h):
	hero = h
# Called when the node enters the scene tree for the first time.
func _ready():
	hero = HeroTypes.asteria
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
