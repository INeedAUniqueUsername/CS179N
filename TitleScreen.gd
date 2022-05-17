extends Control
func _ready():
	$Play.connect("pressed", self, "play")
func go(scene: PackedScene):
	$MenuSound.play()
	yield($MenuSound, "finished")
	get_tree().change_scene_to(scene)
func play():
	go(preload("res://Scenes/CharacterSelect2.tscn"))
func codex():
	go(preload("res://Codex.tscn"))
func credits():
	go(preload("res://Credits.tscn"))
func quit():
	$MenuSound.play()
	yield($MenuSound, "finished")
	get_tree().quit()


