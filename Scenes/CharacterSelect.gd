extends Node2D

func _ready():
	
	#$VBoxContainer/HBoxContainer2/Asteria.connect("pressed", self, "on_button_Asteria_pressed")
	pass
	
#before each of the setHeros, render the current selected character
func _on_button_Asteria_pressed():
	PlayerVariables.setHero(PlayerVariables.HeroTypes.asteria)
func _on_button_AstroKnight_pressed():
	PlayerVariables.setHero(PlayerVariables.HeroTypes.astroknight)
func _on_button_Lune_pressed():
	PlayerVariables.setHero(PlayerVariables.HeroTypes.lune)
func _on_button_Starman_pressed():
	PlayerVariables.setHero(PlayerVariables.HeroTypes.starman)
