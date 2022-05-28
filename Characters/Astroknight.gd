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

const primaryFireInterval = 0.5
const secondaryFireInterval = 1.6
const primaryEnergyUse = 10
const secondaryEnergyUse = 50

const beam = preload("res://SwordBeam.tscn")
const beamCharged = preload("res://SaberBeam.tscn")
func _process(delta):
	common.update_systems(delta)
	common.update_controls(delta)
	if common.state != common.State.Active:
		return
	if $Anim.current_animation == "Slash":
		return
	if common.is_control_pressed(KEY_Z) && common.fireCooldown < 0 && common.energy > secondaryEnergyUse:
		$SecondaryAttack.play()
		common.energy -= secondaryEnergyUse
		common.fireCooldown = secondaryFireInterval
		$Anim.stop()
		$Anim.play("Slash")
	elif common.is_control_pressed(KEY_X) && common.fireCooldown < 0 && common.energy > primaryEnergyUse:
		$PrimaryAttack.play()
		common.energy -= primaryEnergyUse
		common.fireCooldown = primaryFireInterval
		fire_primary()
func fire_primary():
	var scale = {
		$GunLeft:Vector2(1, -1),
		$GunRight:Vector2(1, 1)
	}
	for p in [$GunLeft, $GunRight]:
		var l
		if $Anim.current_animation == "Slash":
			l = beamCharged.instance()
			l.vel = common.vel + polar2cartesian(1024, p.global_rotation - PI/2)
		else:
			l = beam.instance()
			l.vel = common.vel + polar2cartesian(512, p.global_rotation - PI/2)
			
		l.ignore.append(self)
		
		get_parent().call_deferred("add_child", l)
		l.global_position = p.global_position
		l.global_rotation = p.global_rotation - PI/2
		l.scale = scale[p]
func check_slash_fire():
	if common.is_control_pressed(KEY_X) and common.energy > primaryEnergyUse / 4.0:
		#$PrimaryAttack.play()
		common.energy -= primaryEnergyUse / 4.0
		fire_primary()
	pass
func _physics_process(delta):
	common.update_physics(delta)


func _on_body_animation_finished(anim_name):
	if anim_name == "Slash":
		$Anim.play("Idle")
func _on_body_entered(area):
	pass # Replace with function body.
func _on_sword_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if !actor or actor == self:
		return
	if actor.is_in_group("Projectile") and actor.ignore.has(self):
		return
	if actor.is_in_group("Laser"):
		actor.vel = -actor.vel
		actor.ignore = []
		var na = actor.name
		print(na)
	elif actor.is_in_group("Kinetic"):
		actor.vel += common.vector_up * 240
	elif actor.is_in_group("Lightning"):
		damage(actor)
	elif actor.is_in_group("Projectile"):
		pass
	else:
		actor.damage(self)
var damage = 20
func damage(projectile):
	common.damage(projectile)
	
func add_fuel(f, fm):
	common.add_fuel(f, fm)
	
func add_hp(h, hm):
	common.add_hp(h, hm)
	
func add_energy(e, em):
	common.add_energy(e, em)
