class_name Enemies
extends Node2D

var rotationSpeed = 50
var beamSpeed = 200

var hp = 100 setget, get_hp
func get_hp(): return hp

func takeDamage(dmg: int): hp -= dmg

func _on_Damage_Area_area_entered(area):
	var hit = area.get_parent()
	if hit.is_in_group("projectile"):
		takeDamage(hit.dmg)
		area.get_parent().queue_free()

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
	if target != null:
		look_at(target.global_position)
		rotate(PI/2)
		
# Called to update forward variable
var forward = Vector2(0, 0)
func _process(delta):
	forward = -get_global_transform().orthonormalized().y
