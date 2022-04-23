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


const primaryFireInterval = 0.5
const secondaryFireInterval = 2
const primaryEnergyUse = 10
const secondaryEnergyUse = 50

const beam = preload("res://SwordBeam.tscn")

func _process(delta):
	
	common.update_energy(delta)
	common.update_controls(delta)
	
	if Input.is_key_pressed(KEY_X) && common.fireCooldown < 0 && common.energy > primaryEnergyUse:
		common.energy -= primaryEnergyUse
		common.fireCooldown = primaryFireInterval
		
		for p in [$GunLeft, $GunRight]:
			var l = beam.instance()
			l.ignore.append(self)
			l.vel = common.vel + common.vector_up * 512
			get_parent().add_child(l)
			l.set_global_transform(p.get_global_transform())
			l.rotation_degrees = rotation_degrees - 90
	if Input.is_key_pressed(KEY_Z) && common.fireCooldown < 0 && common.energy > secondaryEnergyUse:
		common.energy -= secondaryEnergyUse
		common.fireCooldown = secondaryFireInterval
		$Anim.play("Slash")
func _physics_process(delta):
	common.update_physics(delta)


func _on_body_animation_finished(anim_name):
	if anim_name == "Slash":
		$Anim.play("Idle")
func _on_body_entered(area):
	pass # Replace with function body.
func _on_sword_entered(area):
	pass # Replace with function body.
