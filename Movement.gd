extends Node2D

onready var vel = Vector2(0, 0)
onready var turn = 0

onready var hp = 100
onready var energy = 100
# time remaining before weapon is ready
# if negative, indicates excess time that has passed (used for battery recharge)
var fireCooldown = 0

var beam = preload("res://LaserBeam.tscn")
func _process(delta):
	if fireCooldown < 0:
		var rechargeRate = 20 - fireCooldown*5
		energy = min(100, energy + delta * rechargeRate)
	
	var vector_up = -get_global_transform().orthonormalized().y
	var up = Input.is_key_pressed(KEY_UP)
	var left = Input.is_key_pressed(KEY_LEFT)
	var right = Input.is_key_pressed(KEY_RIGHT)
	if left and right:
		vel += vector_up * delta * 240
		$AnimationPlayer.play("Thrust")
	elif left:
		turn -= 180 * delta
		$AnimationPlayer.play("TurnLeft")
	elif right:
		turn += 180 * delta
		$AnimationPlayer.play("TurnRight")
	elif up:
		vel += vector_up * delta * 240
		$AnimationPlayer.play("Thrust")
	else:
		$AnimationPlayer.play("Idle")
	
	fireCooldown -= delta
	var energyToFire = 10
	if Input.is_key_pressed(KEY_X) && fireCooldown < 0 && energy > energyToFire:
		energy -= energyToFire
		fireCooldown = fireInterval
		
		for p in [$GunLeft, $GunRight]:
			var l = beam.instance()
			l.vel = vel + vector_up * 1024
			get_parent().add_child(l)
			l.set_global_transform(p.get_global_transform())
			l.rotation_degrees = rotation_degrees + 90
func _physics_process(delta):
	global_translate(vel * delta)
	rotation_degrees += turn * delta
func _on_area_entered(area):
	pass # Replace with function body.
