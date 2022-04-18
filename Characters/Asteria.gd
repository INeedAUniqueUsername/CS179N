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

const primaryFireInterval = 0.1
const secondaryFireInterval = 2
const primaryEnergyUse = 4
const secondaryEnergyUse = 50

var fireCount = 0

const beam = preload("res://PlasmaBall.tscn")

func _process(delta):
	common.update_energy(delta)
	if $Body/Anim.current_animation == "Punch":
		
		var up = Input.is_key_pressed(KEY_UP)
		var left = Input.is_key_pressed(KEY_LEFT)
		var right = Input.is_key_pressed(KEY_RIGHT)
		
		common.fuel -= common.fuelUsage * 2
		if left == right:
			
			common.vel += common.vector_up * delta * common.thrustSpeed * 2
			$LeftLeg/Anim.play("StraightThrust")
			$RightLeg/Anim.play("StraightThrust")
		elif left:
			common.vel += common.vector_up * delta * common.thrustSpeed * 6 / 4
			common.turn -= delta * common.turnSpeed
			$LeftLeg/Anim.play("StraightThrust")
			$RightLeg/Anim.play("Turn")
		elif right:
			common.vel += common.vector_up * delta * common.thrustSpeed * 6 / 4
			common.turn += delta * common.turnSpeed
			$LeftLeg/Anim.play("Turn")
			$RightLeg/Anim.play("StraightThrust")
		return
	common.update_controls(delta)
	if Input.is_key_pressed(KEY_X) && common.fireCooldown < 0 && common.energy > primaryEnergyUse:
		common.energy -= primaryEnergyUse
		common.fireCooldown = primaryFireInterval
		
		fireCount += 1
		var p = [$LeftCannon, $RightCannon][fireCount%2]
		var l = beam.instance()
		l.vel = common.vel + common.vector_up * 1024
		get_parent().add_child(l)
		l.set_global_transform(p.get_global_transform())
		l.rotation_degrees = rotation_degrees - 90
		p.get_node("Anim").play("Fire")
	if Input.is_key_pressed(KEY_Z) && common.fireCooldown < 0 && common.energy > secondaryEnergyUse:
		common.energy -= secondaryEnergyUse
		common.fireCooldown = secondaryFireInterval
		$Body/Anim.play("Punch")
		$LeftLeg/Anim.play("StraightThrust")
		$RightLeg/Anim.play("StraightThrust")
		$LeftCannon/Anim.play("Punch")
		$RightCannon/Anim.play("Punch")
func _physics_process(delta):
	common.update_physics(delta)
func _on_body_animation_finished(anim_name):
	if anim_name == "Punch":
		for a in [$Body, $LeftLeg, $RightLeg, $LeftCannon, $RightCannon]:
			a.get_node("Anim").play("Idle")
func fire_burst():
	
	var p = $BurstOrigin
	
	for angle in [-30, -25, -20, -15, -10, -5, 0, 5, 10, 15, 20, 25, 30]:
		var a = rotation_degrees - 90 + angle
		
		var l = beam.instance()
		l.vel = common.vel + polar2cartesian(1024, a * PI / 180)
		get_parent().add_child(l)
		
		l.set_global_transform(p.get_global_transform())
		
		l.position += polar2cartesian(30, a * PI / 180)
		l.rotation_degrees = a
