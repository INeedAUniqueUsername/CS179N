extends Sprite

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
var fireCount = 0

const beam = preload("res://CrescentBeam.tscn")
const blast = preload("res://CrescentBlast.tscn")


func _process(delta):
	common.update_energy(delta)
	common.update_controls(delta)
	if Input.is_key_pressed(KEY_X) && common.canFire() && common.energy > primaryEnergyUse:
		common.energy -= primaryEnergyUse
		common.fireCooldown = primaryFireInterval
		fireCount += 1
		
		var p = [$GunLeft, $GunRight][fireCount%2]
		
		var l = beam.instance()
		l.vel = common.vel + common.vector_up * 512
		get_parent().add_child(l)
		l.set_global_transform(p.get_global_transform())
		l.rotation_degrees = rotation_degrees - 90
	if Input.is_key_pressed(KEY_Z) && common.canFire() && common.energy > secondaryEnergyUse:
		common.energy -= secondaryEnergyUse
		common.fireCooldown = secondaryFireInterval
		$Anim.play("Cast")
func _physics_process(delta):
	common.update_physics(delta)
func fire_beam():
	var p = [$GunLeft, $GunRight][fireCount%2]
	fireCount += 1
	var l = beam.instance()
	l.vel = common.vel + common.vector_up * 512
	get_parent().add_child(l)
	l.set_global_transform(p.get_global_transform())
	l.rotation_degrees = rotation_degrees - 90
	
func fire_blast():
	var p = $BeamOrigin
	var l = blast.instance()
	l.vel = common.vel + common.vector_up * 750
	get_parent().add_child(l)
	l.set_global_transform(p.get_global_transform())
	l.rotation_degrees = rotation_degrees - 90


func _on_body_animation_finished(name):
	if name == "Cast":
		$Anim.play("Idle")


func _on_area_entered():
	pass # Replace with function body.


func _on_body_entered():
	pass # Replace with function body.
