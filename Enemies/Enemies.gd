class_name Enemies
extends Node2D

var hp = 100 setget, get_hp
func get_hp(): return hp

signal on_destroyed
func damage(projectile):
	hp -= projectile.damage
	if hp < 1:
		if(is_in_group("Stationary")):
			emit_signal("on_destroyed", self)
			get_parent().destroyed()
		else:
			emit_signal("on_destroyed", self)
			var enemydie = AudioStreamPlayer.new()
			get_parent().add_child(enemydie)
			var dieaudio = preload("res://Sound/enemydie_explosionCrunch_000.ogg")
			enemydie.stream = dieaudio
			enemydie.play()
			remove_child(enemydie)
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
