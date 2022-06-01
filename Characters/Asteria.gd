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
const secondaryEnergyUse = 100

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
	if common.is_control_pressed(KEY_X) && common.fireCooldown < 0 && common.energy >= primaryEnergyUse:
		$PrimarySound.play()
		
		var speed = 1024 * 3/4.0
		if common.fireCooldown > -0.1:
			nextCooldown = max(primaryFireInterval / 4, nextCooldown * nextCooldown / (nextCooldown + 0.003))
			speed *= max(1, primaryFireInterval / (nextCooldown * 3.0))
		else:
			nextCooldown = primaryFireInterval
		common.fireCooldown = nextCooldown
		
		common.energy -= max(primaryEnergyUse * nextCooldown / primaryFireInterval, primaryEnergyUse / 4)
		
		fireCount += 1
		var p = [$LeftCannon, $RightCannon][fireCount%2]
		var l = beam.instance()
		l.ignore.append(self)
		l.vel = common.vel + common.vector_up * speed
		get_parent().call_deferred("add_child", l)
		l.set_global_transform(p.get_global_transform())
		l.rotation_degrees = rotation_degrees - 90
		p.get_node("Anim").play("Fire")
	if common.is_control_pressed(KEY_Z) && common.fireCooldown < 0 && common.energy >= secondaryEnergyUse:
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
		$BurstOrigin.global_position,
		common.vel,
		0)
	e.scale *= 2
	e.damage = 20
	e.get_node("Anim").playback_speed = 4
		
	if common.is_control_pressed(KEY_X) and common.energy > primaryEnergyUse * 3:
		common.energy -= primaryEnergyUse * 3
		var p = $BurstOrigin
		for angle in [-30, -20, -10, 0, 10, 20, 30]:
			var a = rotation_degrees - 90 + angle
			
			var l = beam.instance()
			l.ignore.append(self)
			l.vel = common.vel + polar2cartesian(1024 * 3/4, a * PI / 180)
			get_parent().call_deferred("add_child", l)
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
	
func add_fuel(f, fm):
	common.add_fuel(f, fm)
	
func add_hp(h, hm):
	common.add_hp(h, hm)
	
func add_energy(e, em):
	common.add_energy(e, em)
