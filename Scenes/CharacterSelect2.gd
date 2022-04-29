extends Control
func _ready():
	$Starman.connect("pressed", self, "select_starman")
	$Asteria.connect("pressed", self, "select_asteria")
	$Astroknight.connect("pressed", self, "select_astroknight")
	$Lune.connect("pressed", self, "select_lune")
	$"Start Game".connect("pressed", self, "start_game")
	select_starman()
func start_game():
	get_tree().change_scene("res://Scenes/Level.tscn")
func reset_borders():
	for b in [$Starman, $Asteria, $Astroknight, $Lune]:
		b.get_node("Border").visible = false
func vis(b):
	reset_borders()
	b.visible = true
func select_starman():
	vis($Starman/Border)
	$Character.texture = $Starman/Sprite.texture
	PlayerVariables.setHero(PlayerVariables.HeroTypes.starman)
func select_asteria():
	vis($Asteria/Border)
	$Character.texture = $Asteria/Sprite.texture
	PlayerVariables.setHero(PlayerVariables.HeroTypes.asteria)
func select_astroknight():
	vis($Astroknight/Border)
	$Character.texture = $Astroknight/Sprite.texture
	PlayerVariables.setHero(PlayerVariables.HeroTypes.astroknight)
func select_lune():
	vis($Lune/Border)
	$Character.texture = $Lune/Sprite.texture
	PlayerVariables.setHero(PlayerVariables.HeroTypes.lune)
	
