class_name Enemies
extends Node2D

var speed = 10
var vel = Vector2(0, 0)
var turn = 0

var hp = 100 setget, get_hp
func get_hp(): return hp

var atk_radius = 40 setget set_radius, get_radius
func set_radius(r): atk_radius = r
func get_radius(): return atk_radius

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

func _on_area_entered(area):
	var p = area.get_parent()
	if p.is_in_group("Player"):
		target = p
func _process(delta):
	if target != null:
		# FIX ANGLE BUG
		var offset = target.global_position - global_position
		offset = offset.angle() - rotation
		if offset > PI:
			offset -= 2 * PI
		if offset < -PI:
			offset += PI * 2
			
		var speed = PI / 90
		offset = offset / 30
		if abs(offset) > speed:
			offset = sign(offset) * speed
		rotation += offset
