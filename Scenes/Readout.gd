extends Control

var boss
# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("register_player")
func register_player():
	var actors = get_parent().get_parent().get_node("Actors")
	player = actors.player
	actors.connect("on_boss_summoned", self, "on_boss_summoned")
	actors.connect("on_boss_destroyed", self, "on_boss_destroyed")
func on_boss_summoned(b):
	boss = b
	$Anim.play("BossWarning")
func on_boss_destroyed():
	boss = null
	$Anim.play("LevelCleared")
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
	
	$HealthFront.region_rect.size.x = ceil(width.hp)
	$EnergyFront.region_rect.size.x = ceil(width.energy)
	$FuelFront.region_rect.size.x = ceil(width.fuel)
	$BossFront.region_rect.size.x = ceil(width.boss)
