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
	
const primaryFireInterval = 0.12
const secondaryFireInterval = 2
const primaryEnergyUse = 4
const secondaryEnergyUse = 50

var nextCooldown = primaryFireInterval

var fireCount = 0

const beam = preload("res://PlasmaBall.tscn")

func _process(delta):
	common.update_systems(delta)
	common.update_controls(delta)
	
	if common.state != common.State.Active:
		return
	if $Anim.current_animation == "Punch":
		for la in [$LeftLeg/Anim, $RightLeg/Anim]:
			match la.current_animation:
				"Idle":
					la.play("StraightIdle")
				"Thrust":
					la.play("StraightThrust")
		return
	if Input.is_key_pressed(KEY_X) && common.fireCooldown < 0 && common.energy > primaryEnergyUse:
		$PrimarySound.play()
		
		if common.fireCooldown > -0.1:
			nextCooldown = max(primaryFireInterval / 3, nextCooldown * nextCooldown / (nextCooldown + 0.003))
		else:
			nextCooldown = primaryFireInterval
		common.fireCooldown = nextCooldown
		
		common.energy -= max(primaryEnergyUse * nextCooldown / primaryFireInterval, primaryEnergyUse / 3)
		
		fireCount += 1
		var p = [$LeftCannon, $RightCannon][fireCount%2]
		var l = beam.instance()
		l.ignore.append(self)
		l.vel = common.vel + common.vector_up * 1024 * 3/4
		get_parent().add_child(l)
		l.set_global_transform(p.get_global_transform())
		l.rotation_degrees = rotation_degrees - 90
		p.get_node("Anim").play("Fire")
	if Input.is_key_pressed(KEY_Z) && common.fireCooldown < 0 && common.energy > secondaryEnergyUse:
		#$AsteriaSecondarySound.play()
		common.energy -= secondaryEnergyUse
		common.fireCooldown = secondaryFireInterval
		
		
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
func check_fire_back():
	pass
func fire_burst():
	$PrimarySound.play()
	var e = Helper.create_projectile(
		explosion,
		get_parent(),
		[self],
		global_position,
		common.vel,
		0)
	e.scale *= 2
	e.damage = 20
	e.get_node("Anim").playback_speed = 4
		
	if Input.is_key_pressed(KEY_X) and common.energy > primaryEnergyUse / 4.0:
		common.energy -= primaryEnergyUse
		var p = $BurstOrigin
		for angle in [-30, -20, -10, 0, 10, 20, 30]:
			var a = rotation_degrees - 90 + angle
			
			var l = beam.instance()
			l.ignore.append(self)
			l.vel = common.vel + polar2cartesian(1024 * 3/4, a * PI / 180)
			get_parent().add_child(l)
			
			l.set_global_transform(p.get_global_transform())
			
			l.position += polar2cartesian(30, a * PI / 180)
			l.rotation_degrees = a
var explosion = preload("res://MissileExplosion.tscn")
func take_damage(dmg):
	common.hp -= dmg

func _on_body_entered(area):
	pass # Replace with function body.
func damage(projectile):
	common.damage(projectile)
	
func add_fuel(f):
	common.add_fuel(f)
	
func add_hp(h):
	common.add_hp(h)
