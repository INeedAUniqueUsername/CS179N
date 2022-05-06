class_name Enemies
extends Node2D

var hp = 100 setget, get_hp
func get_hp(): return hp

signal on_destroyed
func damage(projectile):
	hp -= projectile.damage
	if hp < 1:
		if(is_in_group("Stationary")):
			get_parent().destroyed()
		else:
			emit_signal("on_destroyed", self)
			queue_free()

var damage = 30
var ignore_target = 0
var ignore_time = 2
func _on_Damage_Area_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
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
		look_at(target.global_position)
		
# Called to update forward variable
var forward = Vector2(0, 0)
func _process(delta):
	forward = get_global_transform().orthonormalized().x
