class_name Enemies
extends Node2D

var hp = 100 setget, get_hp
func get_hp(): return hp

var rng = RandomNumberGenerator.new()
const health_pickup = preload("res://Powerups/HealthPickup.tscn")
const fuel_pickup = preload("res://Powerups/FuelPickup.tscn")

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
		if(rand < 20):
			if(rand < 10):
				var health_load = health_pickup.instance()
				get_parent().add_child(health_load)
				health_load.set_global_transform(get_global_transform())
			else:
				var fuel_load = fuel_pickup.instance()
				get_parent().add_child(fuel_load)
				fuel_load.set_global_transform(get_global_transform())
		
		if(is_in_group("Stationary")):
			get_parent().destroyed()
		else:
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
		actor.damage(self)
		ignore_target = ignore_time

# Triggered when player enter's enemy's attack radius
var atk_target
func _on_Attack_Area_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		atk_target = actor
		
# Triggered when player exits enemy's attack radius
func _on_Attack_Area_area_exited(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		atk_target = null

# Triggered when player enters enemy's detection radius
func _on_Detect_Area_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		target = actor

# Triggered when player exits enemy's detection radius 
func _on_Detect_Area_area_exited(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		target = null

# Called every frame to constantly look at the target
var target
func _physics_process(delta):
	if target && ignore_target <= 0:
		var offset = target.global_position - global_position
		var targetAngle = atan2(offset.y, offset.x)
		var angleDiff = targetAngle - rotation
		angleDiff = atan2(sin(angleDiff), cos(angleDiff))
		var turnRate = PI * 2 / 3
		rotate(sign(angleDiff) * min(abs(angleDiff), delta * turnRate))
		
# Called to update forward variable
var forward = Vector2(0, 0)
func _process(delta):
	forward = get_global_transform().orthonormalized().x
