extends Control
var boss
func _ready():
	call_deferred("register_player")
var actors
func register_player():
	actors = get_parent().get_parent().get_node("Actors")
	player = actors.player
	var c = player.common
	c.connect("on_mortal", self, "on_player_mortal")
	c.connect("on_destroyed", self, "on_player_destroyed")
	c.connect("on_fuel_warning", self, "on_player_fuel_warning")
	c.connect("on_fuel_depleted", self, "on_player_fuel_depleted")
	actors.connect("on_boss_summoned", self, "on_boss_summoned")
	actors.connect("on_beacon_destroyed", self, "on_beacon_destroyed")
	
	$Beacons.text = "Beacons remaining: %d" % len(actors.bossSummon)
func on_player_fuel_warning(pl):
	if $Anim.current_animation == "MortalFlash":
		$Anim.stop()
		$Anim.play("FuelWarningRepaired")
	else:
		$Anim.stop()
		$Anim.play("FuelWarning")
		
func on_player_done():
	PlayerVariables.totalTime += player.common.levelTime
	PlayerVariables.totalScore += player.common.levelScore
		
func on_player_fuel_depleted(pl):
	if $Anim.current_animation == "MortalFlash":
		on_player_done()
		$Anim.stop()
		$Anim.play("GameOverRepairFailed")
	elif pl.state == pl.State.Dying:
		on_player_done()
		$Anim.stop()
		$Anim.play("OutOfFuel2")
	else:
		$Anim.stop()
		$Anim.play("OutOfFuel1")
func on_player_mortal(pl):
	$Anim.stop()
	$Anim.play("MortalFlash")
func on_player_destroyed(pl):
	$Anim.stop()
	$Anim.play("GameOver")
func on_beacon_destroyed(n):
	$Beacons.text = "Beacons remaining: %d" % len(actors.bossSummon)
func on_boss_summoned(b):
	boss = b
	$Boss/Name.text = b.bossName
	$Anim.stop()
	$Anim.play("BossWarning")
	
	
	boss.connect("on_destroyed", self, "on_boss_destroyed")
	
const shake = preload("res://Shake.tscn")
func on_boss_destroyed(b):
	boss = null
	if player.common.state != player.common.State.Active:
		yield(player.common, "on_recovered")
		
		var t = Timer.new()
		t.wait_time = 4
		add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
	get_parent().add_child(shake.instance())
	$Anim.stop()
	$Anim.play("LevelCleared")
	player.common.state = player.common.State.Winner
	on_player_done()
	
	$LevelCleared/LevelTime.text %= player.common.levelTime
	$LevelCleared/TotalTime.text %= PlayerVariables.totalTime
	$LevelCleared/LevelScore.text %= player.common.levelScore
	$LevelCleared/TotalScore.text %= PlayerVariables.totalScore
var player
var width = {
	'hp':0,
	'energy':0,
	'fuel':0,
	'boss':0
}
var dest_width = {
	'hp':0,
	'energy':0,
	'fuel':0,
	'boss':0
}
var skipLevelOutro = false
var levelOutroReady = false
func _process(delta):
	
	dest_width.hp = int(96 * player.hp / player.common.hp_max)
	dest_width.energy = int(96 * player.energy / player.common.energy_max)
	dest_width.fuel = int(96 * player.fuel / player.common.fuel_max)
	if boss and boss.hp:
		dest_width.boss = int(420 * boss.hp / boss.hp_max)
	
	width.hp += (dest_width.hp - width.hp)/10.0
	width.energy += (dest_width.energy - width.energy)/10.0
	width.fuel += (dest_width.fuel - width.fuel)/10.0
	width.boss += (dest_width.boss - width.boss) / 10.0
	
	$Bars/HealthFront.region_rect.size.x = ceil(width.hp)
	$Bars/EnergyFront.region_rect.size.x = ceil(width.energy)
	$Bars/FuelFront.region_rect.size.x = ceil(width.fuel)
	$Bars/Time.text = "Time: %.2f sec" % player.common.levelTime
	$Bars/Score.text = "Score: %d" % player.common.levelScore
	$Boss/Front.region_rect.size.x = ceil(width.boss)
	if Input.is_key_pressed(KEY_ENTER):
		check_next_screen()
	if Input.is_key_pressed(KEY_SPACE):
		check_resurrect()
func check_next_screen():
	if $Anim.current_animation == "LevelCleared" and $Anim.current_animation_position < 4:
		skipLevelOutro = true
	elif levelOutroReady:
		var s = shake.instance()
		s.set_lifetime(3)
		get_parent().add_child(s)
		$Anim.stop()
		$Anim.play("NextLevel")
	elif gameOver:
		PlayerVariables.set_winner(false)
		get_tree().change_scene("res://Scenes/Ending.tscn")
func check_resurrect():
	if $Anim.current_animation == "LevelCleared" or levelOutroReady:
		return
	if gameOver:
		gameOver = false
		player.common.resurrect()
		$Anim.play("Resurrected")
func check_skip_outro():
	if skipLevelOutro:
		go_next_level()
func set_outro_ready():
	levelOutroReady = true
func go_next_level():
	if PlayerVariables.inc_level():
		get_tree().change_scene("res://Scenes/Level.tscn")
	else:
		get_tree().change_scene("res://Scenes/Ending.tscn")
var gameOver = false
func game_over():
	gameOver = true
