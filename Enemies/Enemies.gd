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

# Triggered when player enter's enemy's attack radius
const beam = preload("res://LaserBeam.tscn")
var atk_target
func _on_Attack_Area_area_entered(area):
	var p = area.get_parent()
	if p.is_in_group("Player"):
		atk_target = p
		
# Triggered when player exits enemy's attack radius
func _on_Attack_Area_area_exited(area):
	var p = area.get_parent()
	if p.is_in_group("Player"):
		atk_target = null

# Triggered when player enters enemy's detection radius
func _on_Detect_Area_area_entered(area):
	var p = area.get_parent()
	if p.is_in_group("Player"):
		target = p

# Triggered when player exits enemy's detection radius 
func _on_Detect_Area_area_exited(area):
	var p = area.get_parent()
	if p.is_in_group("Player"):
		target = null

# Called every frame to constantly look at the target
var target
var base_cooldown = 3
var curr_cooldown = 0
func _physics_process(delta):
	curr_cooldown -= delta
	if target != null:
		look_at(target.global_position)
		rotate(PI/2)
	if atk_target != null and curr_cooldown < 0:
		curr_cooldown = base_cooldown
		var beam_load = beam.instance()
		beam_load.vel = forward * beamSpeed
		get_parent().add_child(beam_load)
		beam_load.set_global_transform(get_global_transform())
		beam_load.rotation_degrees = rotation_degrees - 90
		
# Called to update forward variable
var forward = Vector2(0, 0)
func _process(delta):
	forward = -get_global_transform().orthonormalized().y
