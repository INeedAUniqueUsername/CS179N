class_name Enemies
extends Node2D

var rotationSpeed = 50

var hp = 100 setget, get_hp
func get_hp(): return hp

func takeDamage(dmg: int): hp -= dmg

var target

func _on_Damage_Area_area_entered(area):
	pass # Replace with function body.

func _on_Attack_Area_area_entered(area):
	pass # Replace with function body.

# Triggered when player moves into enemy's detection radius
func _on_Detect_Area_area_entered(area):
	var p = area.get_parent()
	if p.is_in_group("Player"):
		target = p

func _on_Detect_Area_area_exited(area):
	var p = area.get_parent()
	if p.is_in_group("Player"):
		target = null

func _physics_process(delta):
	if target != null:
		look_at(target.global_position)
		rotate(PI/2)
