extends Control


const HeroTypes = PlayerVariables.HeroTypes

export (NodePath) var dropdown_path
onready var dropdown = get_node(dropdown_path)

var difficulty_array = ["Easy", "Normal", "Hard"]


func _ready():
	var s = "button_down"
	add_difficulty_items()
	dropdown.connect("item_selected", self, "on_item_selected")
	$Starman.connect(s, self, "select_starman")
	$Asteria.connect(s, self, "select_asteria")
	$Astroknight.connect(s, self, "select_astroknight")
	$Lune.connect(s, self, "select_lune")
	$BackButton.connect("pressed", self, "back")
	$StartButton.connect("pressed", self, "start_game")

	
	if PlayerVariables.gold[HeroTypes.starman]:
		set_gold($Starman/Back)
	if PlayerVariables.gold[HeroTypes.asteria]:
		set_gold($Asteria/Back)
	if PlayerVariables.gold[HeroTypes.astroknight]:
		set_gold($Astroknight/Back)
	if PlayerVariables.gold[HeroTypes.lune]:
		set_gold($Lune/Back)
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
	$Desc.text = PlayerVariables.heroDesc[PlayerVariables.hero]

const gold = preload("res://Sprites/CharacterBackgroundGold.png")
func set_gold(back : Sprite):
	back.texture = gold

	select_starman()
func add_difficulty_items():
	for item in difficulty_array:
		dropdown.add_item(item)

func on_item_selected(id):
	SetDifficulty.state = id
	SetDifficulty.emit_signal("level_difficulty")
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
	$Desc.text = PlayerVariables.heroDesc[PlayerVariables.hero]
	$Character.texture = $Starman/Sprite.texture
func select_asteria():
	$MenuClickSound.play()
	PlayerVariables.setHero(HeroTypes.asteria)
	vis($Asteria/Border)
	$Desc.text = PlayerVariables.heroDesc[PlayerVariables.hero]
	$Character.texture = $Asteria/Sprite.texture
func select_astroknight():
	$MenuClickSound.play()
	PlayerVariables.setHero(HeroTypes.astroknight)
	vis($Astroknight/Border)
	$Desc.text = PlayerVariables.heroDesc[PlayerVariables.hero]
	$Character.texture = $Astroknight/Sprite.texture
func select_lune():
	$MenuClickSound.play()
	PlayerVariables.setHero(HeroTypes.lune)
	vis($Lune/Border)
	$Desc.text = PlayerVariables.heroDesc[PlayerVariables.hero]
	$Character.texture = $Lune/Sprite.texture
