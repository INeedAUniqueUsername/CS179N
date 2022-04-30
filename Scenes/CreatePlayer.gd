extends Node
var HeroTypes = PlayerVariables.HeroTypes
var heroes = {
	HeroTypes.starman: load("res://Characters/Starman.tscn"),
	HeroTypes.asteria: load("res://Characters/Asteria.tscn"),
	HeroTypes.astroknight: load("res://Characters/Astroknight.tscn"),
	HeroTypes.lune: load("res://Characters/Lune.tscn")
}
func _ready():
	add_child(heroes[PlayerVariables.hero].instance())
	call_deferred("remove_self")
func remove_self():
	for c in get_children():
		remove_child(c)
		get_parent().add_child(c)
