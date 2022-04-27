extends Node2D

var vel setget, get_vel
var fireCooldown setget, get_fire_cooldown
var hp setget, get_hp
var energy setget, get_energy
var fuel setget, get_fuel
func get_vel(): return common.vel
func get_fire_cooldown(): return common.fireCooldown
func get_hp(): return common.hp
func get_energy(): return common.energy
func get_fuel(): return common.fuel

onready var common = load("res://Characters/Common.gd").new(self, $Anim, $LeftLeg/Anim, $RightLeg/Anim)
func set_time_scale(t):
	common.set_time_scale(t)
	
const primaryFireInterval = 0.15
const secondaryFireInterval = 0
const primaryEnergyUse = 6
const secondaryEnergyUse = 50

const beam = preload("res://LaserBeam.tscn")

func _process(delta):
	common.update_systems(delta)
	common.update_controls(delta)
	if Input.is_key_pressed(KEY_X) && common.fireCooldown < 0 && common.energy > primaryEnergyUse:
		common.energy -= primaryEnergyUse
		common.fireCooldown = primaryFireInterval
		
		for p in [$LeftCannon, $RightCannon]:
			var l = beam.instance()
			l.ignore.append(self)
			l.vel = common.vel + common.vector_up * 1024
			get_parent().add_child(l)
			l.set_global_transform(p.get_global_transform())
			l.rotation_degrees = rotation_degrees - 90
			p.get_node("Anim").play("Fire")
	if $Anim.current_animation == "Punch":
		return
	if Input.is_key_pressed(KEY_Z) && common.fireCooldown < 0 && common.energy > secondaryEnergyUse:
		common.energy -= secondaryEnergyUse
		common.fireCooldown = secondaryFireInterval
		
		common.vel += polar2cartesian(720, rotation - PI/2)
		$Anim.play("Punch")
		$LeftLeg/Anim.play("StraightThrust")
		$RightLeg/Anim.play("StraightThrust")
		$LeftCannon/Anim.play("Punch")
		$RightCannon/Anim.play("Punch")
func _physics_process(delta):
	common.update_physics(delta)
func _on_body_animation_finished(anim_name):
	if anim_name == "Punch":
		for a in [self, $LeftLeg, $RightLeg, $LeftCannon, $RightCannon]:
			a.get_node("Anim").play("Idle")
func _on_body_entered():
	pass # Replace with function body.
	
func damage(projectile):
	common.damage(projectile)

var damage
func _on_cannon_entered(area):
	if $Anim.current_animation != "Punch":
		return
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if !actor:
		return
	if actor.is_in_group("Stationary"):
		var velDiff = common.vel - actor.vel
		common.vel -= velDiff * 1.5
		damage = velDiff.length() / 8
	else:
		var velDiff = common.vel - actor.vel
		actor.vel += velDiff / 2
		common.vel -= velDiff / 2
		damage = velDiff.length() / 8
	actor.damage(self)
	
	actor.vel += polar2cartesian(120, rotation - PI/2)
