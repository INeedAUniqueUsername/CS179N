extends Control
func _ready():
	var s = "button_down"
	$Starman.connect(s, self, "select_starman")
	$Asteria.connect(s, self, "select_asteria")
	$Astroknight.connect(s, self, "select_astroknight")
	$Lune.connect(s, self, "select_lune")
	$BackButton.connect("pressed", self, "back")
	$StartButton.connect("pressed", self, "start_game")
	select_starman()
func back():
	$MenuClickSound.play()
	yield($MenuClickSound,"finished")
	get_tree().change_scene("res://Title.tscn")
func _process(delta):
	if $Anim.current_animation == "Flash":
		return
	if Input.is_key_pressed(KEY_1):
		select_starman()
	elif Input.is_key_pressed(KEY_2):
		select_asteria()
	elif Input.is_key_pressed(KEY_3):
		select_astroknight()
	elif Input.is_key_pressed(KEY_4):
		select_lune()
	elif Input.is_key_pressed(KEY_X):
		start_game()
const shake = preload("res://Shake.tscn")
func start_game():
	$MenuClickSound.play()
	PlayerVariables.reset()
	var s = shake.instance()
	s.set_lifetime(4)
	$Camera.add_child(s)
	$BackButton.queue_free()
	$StartButton.queue_free()
	$Anim.play("Flash")
	$Anim.connect("animation_finished", self, "change_scene")
func change_scene(an):
	get_tree().change_scene("res://Scenes/Level.tscn")
func reset_borders():
	for b in [$Starman, $Asteria, $Astroknight, $Lune]:
		b.get_node("Border").visible = false
func vis(b):
	reset_borders()
	b.visible = true
func select_starman():
	$MenuClickSound.play()
	PlayerVariables.setHero(PlayerVariables.HeroTypes.starman)
	vis($Starman/Border)
	$Desc.text = PlayerVariables.heroDesc[PlayerVariables.hero]
	$Character.texture = $Starman/Sprite.texture
func select_asteria():
	$MenuClickSound.play()
	PlayerVariables.setHero(PlayerVariables.HeroTypes.asteria)
	vis($Asteria/Border)
	$Desc.text = PlayerVariables.heroDesc[PlayerVariables.hero]
	$Character.texture = $Asteria/Sprite.texture
func select_astroknight():
	$MenuClickSound.play()
	PlayerVariables.setHero(PlayerVariables.HeroTypes.astroknight)
	vis($Astroknight/Border)
	$Desc.text = PlayerVariables.heroDesc[PlayerVariables.hero]
	$Character.texture = $Astroknight/Sprite.texture
func select_lune():
	$MenuClickSound.play()
	PlayerVariables.setHero(PlayerVariables.HeroTypes.lune)
	vis($Lune/Border)
	$Desc.text = PlayerVariables.heroDesc[PlayerVariables.hero]
	$Character.texture = $Lune/Sprite.texture
