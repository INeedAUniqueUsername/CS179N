extends Control

var boss
# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("register_player")
func register_player():
	var actors = get_parent().get_parent().get_node("Actors")
	player = actors.player
	player.common.connect("on_mortal", self, "on_player_mortal")
	player.common.connect("on_destroyed", self, "on_player_destroyed")
	actors.connect("on_boss_summoned", self, "on_boss_summoned")
	actors.connect("on_boss_destroyed", self, "on_boss_destroyed")
func on_player_mortal(pl):
	$Anim.play("MortalFlash")
func on_player_destroyed(pl):
	$Anim.play("GameOver")
func on_boss_summoned(b):
	boss = b
	$BossLabel.text = b.bossName
	$Anim.play("BossWarning")
	
const shake = preload("res://Shake.tscn")
func on_boss_destroyed():
	boss = null
	get_parent().add_child(shake.instance())
	$Anim.play("LevelCleared")
	player.common.state = player.common.State.Winner
	$LevelCleared/LevelTime.text %= player.common.levelTime
	$LevelCleared/TotalTime.text %= player.common.levelTime
	$LevelCleared/LevelScore.text %= player.common.levelScore
	$LevelCleared/TotalScore.text %= player.common.levelScore
	
var player
# Called every frame. 'delta' is the elapsed time since the previous frame.

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
func _process(delta):
	dest_width.hp = int(96 * player.hp / 100)
	dest_width.energy = int(96 * player.energy / 100)
	dest_width.fuel = int(96 * player.fuel / 100)
	if boss:
		dest_width.boss = int(420 * boss.hp / boss.hp_max)
	
	width.hp += (dest_width.hp - width.hp)/15.0
	width.energy += (dest_width.energy - width.energy)/15.0
	width.fuel += (dest_width.fuel - width.fuel)/15.0
	width.boss += (dest_width.boss - width.boss) / 15.0
	
	$Bars/HealthFront.region_rect.size.x = ceil(width.hp)
	$Bars/EnergyFront.region_rect.size.x = ceil(width.energy)
	$Bars/FuelFront.region_rect.size.x = ceil(width.fuel)
	$Bars/Time.text = "Time: %.2f sec" % player.common.levelTime
	
	$BossFront.region_rect.size.x = ceil(width.boss)
