extends Control


const HeroTypes = PlayerVariables.HeroTypes
var difficulty_array = ["Easy", "Normal", "Hard"]


func _ready():
	var s = "button_down"
	
	for item in difficulty_array:
		$DifficultyButton.add_item(item)
	$DifficultyButton.connect("item_selected", self, "on_item_selected")
	$DifficultyButton.select(PlayerVariables.difficulty)
	$Starman.connect(s, self, "select_starman")
	$Asteria.connect(s, self, "select_asteria")
	$Astroknight.connect(s, self, "select_astroknight")
	$Lune.connect(s, self, "select_lune")
	$BackButton.connect("pressed", self, "back")
	$StartButton.connect("pressed", self, "start_game")
	
	update_frames()
	match PlayerVariables.hero:
		HeroTypes.starman:
			vis($Starman/Border)
			$Character.texture = $Starman/Sprite.texture
		HeroTypes.asteria:
			vis($Asteria/Border)
			$Character.texture = $Asteria/Sprite.texture
		HeroTypes.astroknight:
			vis($Astroknight/Border)
			$Character.texture = $Astroknight/Sprite.texture
		HeroTypes.lune:
			vis($Lune/Border)
			$Character.texture = $Lune/Sprite.texture
	show_stats()
const back_regular = preload("res://Sprites/CharacterBackgroundRegular.png")
const back_gold = preload("res://Sprites/CharacterBackgroundGold.png")
func set_back(back : Sprite, gold: bool = true):
	back.texture = {false:back_regular, true:back_gold}[gold]
func update_frames():
	var d = PlayerVariables.records[PlayerVariables.difficulty]
	set_back($Starman/Back, !!d[HeroTypes.starman])
	set_back($Asteria/Back, !!d[HeroTypes.asteria])
	set_back($Astroknight/Back, !!d[HeroTypes.astroknight])
	set_back($Lune/Back, !!d[HeroTypes.lune])
func on_item_selected(id):
	PlayerVariables.difficulty = id
	update_frames()
	show_stats()
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
	PlayerVariables.setHero(HeroTypes.starman)
	vis($Starman/Border)
	$Character.texture = $Starman/Sprite.texture
	show_stats()
func select_asteria():
	$MenuClickSound.play()
	PlayerVariables.setHero(HeroTypes.asteria)
	vis($Asteria/Border)
	$Character.texture = $Asteria/Sprite.texture
	show_stats()
func select_astroknight():
	$MenuClickSound.play()
	PlayerVariables.setHero(HeroTypes.astroknight)
	vis($Astroknight/Border)
	$Character.texture = $Astroknight/Sprite.texture
	show_stats()
func select_lune():
	$MenuClickSound.play()
	PlayerVariables.setHero(HeroTypes.lune)
	vis($Lune/Border)
	$Character.texture = $Lune/Sprite.texture
	show_stats()
func show_stats():
	$Desc.text = PlayerVariables.heroDesc[PlayerVariables.hero]
	var entry = PlayerVariables.records[PlayerVariables.difficulty][PlayerVariables.hero]
	if entry:
		$Stats.text = "Best Time: %.2f sec\nHigh Score: %d pts" % [entry.bestTime, entry.highScore]
	else:
		$Stats.text = "Best Time: ???\nHigh Score: ???"
