class_name Enemies
extends Node2D

onready var body = self

var hp = 100 setget, get_hp
func get_hp(): return hp

var rng = RandomNumberGenerator.new()
const health_pickup = preload("res://Powerups/HealthPickup.tscn")
const fuel_pickup = preload("res://Powerups/FuelPickup.tscn")
const energy_pickup = preload("res://Powerups/EnergyPickup.tscn")

signal on_destroyed
func damage(projectile):
	hp -= projectile.damage
	if hp < 1:
		emit_signal("on_destroyed", self)
		var enemydie = AudioStreamPlayer.new()
		get_parent().add_child(enemydie)
		var dieaudio = preload("res://Sound/enemydie_explosionCrunch_000.ogg")
		enemydie.stream = dieaudio
		enemydie.play()
		remove_child(enemydie)
		
		rng.randomize()
		var rand = rng.randf_range(0, 100)
		
		if rand < 25:
			var d = health_pickup.instance()
			get_parent().add_child(d)
			d.global_position = global_position
		elif rand < 50:
			var d = fuel_pickup.instance()
			get_parent().add_child(d)
			d.global_position = global_position
		elif rand < 75:
			var d = energy_pickup.instance()
			get_parent().add_child(d)
			d.global_position = global_position
		
		queue_free()

var damage = 30
var ignore_target = 0
var ignore_time = 2
func _on_Damage_Area_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		if 'vel' in self:
			var velDiff = self.vel - actor.common.vel
			actor.common.vel += velDiff / 2
			self.vel -= velDiff
		#actor.damage(self)
		#ignore_target = ignore_time

# Triggered when player enter's enemy's attack radius
var attackable = []
var atk_target
func _on_Attack_Area_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		attackable.append(actor)
		atk_target = attackable[0]
		
# Triggered when player exits enemy's attack radius
func _on_Attack_Area_area_exited(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		attackable.erase(actor)
		if attackable.empty():
			atk_target = null
		else:
			atk_target = attackable[0]
var detected = []
# Triggered when player enters enemy's detection radius
func _on_Detect_Area_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		detected.append(actor)
		target = detected[0]

# Triggered when player exits enemy's detection radius 
func _on_Detect_Area_area_exited(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		detected.erase(actor)
		if detected.empty():
			target = null
		else:
			target = detected[0]

var time_scale = 1.0
func set_time_scale(t):
	time_scale = t
# Called every frame to constantly look at the target
var target
func _physics_process(delta):
	delta *= time_scale
	if target && ignore_target <= 0:
		var offset = target.global_position - global_position
		var targetAngle = atan2(offset.y, offset.x)
		var angleDiff = targetAngle - body.rotation
		angleDiff = atan2(sin(angleDiff), cos(angleDiff))
		var turnRate = PI * 2 / 3
		body.rotate(sign(angleDiff) * min(abs(angleDiff), delta * turnRate))
		
# Called to update forward variable
var forward = Vector2(0, 0)
func _process(delta):
	forward = body.get_global_transform().orthonormalized().x
