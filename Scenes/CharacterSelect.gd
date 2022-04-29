extends Node2D

var asteria = preload("res://Characters/Asteria.tscn").instance()
var astroknight = preload("res://Characters/Astroknight.tscn").instance()
var lune = preload("res://Characters/Lune.tscn").instance()
var starman = preload("res://Characters/Starman.tscn").instance()

func _ready():
	var player_character = load(asteria).instance()
	player_character.start_position = Vector2(100,100)
	add_child(player_character)
