extends Sprite

onready var vel = Vector2(0, 0)
onready var turn = 0

onready var hp = 100
onready var energy = 100
onready var fuel = 100

const primaryFireInterval = 0.5
const secondaryFireInterval = 2
const primaryEnergyUse = 10
const secondaryEnergyUse = 50

# time remaining before weapon is ready
# if negative, indicates excess time that has passed (used for battery recharge)
var fireCooldown = 0

var fireCount = 0

const beam = preload("res://CrescentBeam.tscn")
const blast = preload("res://CrescentBlast.tscn")

func _process(delta):
	fireCooldown -= delta
	if fireCooldown < 0:
		var rechargeRate = 10 - fireCooldown*5
		var inc = min(100 - energy, delta * rechargeRate)
		if inc >= 0:
			energy += inc
			fuel -= inc / 90
	
	var vector_up = -get_global_transform().orthonormalized().y
	
	var up = Input.is_key_pressed(KEY_UP)
	var left = Input.is_key_pressed(KEY_LEFT)
	var right = Input.is_key_pressed(KEY_RIGHT)
	
	var fuelUsage = 1.0/90
	var thrustSpeed = 240
	var turnSpeed = 180
	if $Anim.current_animation == "Slash":
		fuel -= fuelUsage * 2
		if left == right:
			
			vel += vector_up * delta * thrustSpeed * 2
			$LeftLeg/Anim.play("StraightThrust")
			$RightLeg/Anim.play("StraightThrust")
		elif left:
			vel += vector_up * delta * thrustSpeed * 6 / 4
			turn -= delta * turnSpeed
			$LeftLeg/Anim.play("StraightThrust")
			$RightLeg/Anim.play("Turn")
		elif right:
			vel += vector_up * delta * thrustSpeed * 6 / 4
			turn += delta * turnSpeed
			$LeftLeg/Anim.play("Turn")
			$RightLeg/Anim.play("StraightThrust")
		return
	if up:
		fuel -= fuelUsage
		if left == right:
			vel += vector_up * delta * thrustSpeed
			$LeftLeg/Anim.play("Thrust")
			$RightLeg/Anim.play("Thrust")
		elif left:
			turn -= delta * turnSpeed / 2
			vel += vector_up * delta * thrustSpeed * 3/4
			$LeftLeg/Anim.play("Thrust")
			$RightLeg/Anim.play("Turn")
		elif right:
			turn += delta * turnSpeed / 2
			vel += vector_up * delta * thrustSpeed * 3/4
			$LeftLeg/Anim.play("Turn")
			$RightLeg/Anim.play("Thrust")
	elif left and right:
		fuel -= fuelUsage
		vel += vector_up * delta * thrustSpeed
		$LeftLeg/Anim.play("Turn")
		$RightLeg/Anim.play("Turn")
	elif left:
		fuel -= fuelUsage / 2
		turn -= delta * turnSpeed
		$LeftLeg/Anim.play("Idle")
		$RightLeg/Anim.play("Turn")
	elif right:
		fuel -= fuelUsage / 2
		turn += delta * turnSpeed
		$LeftLeg/Anim.play("Turn")
		$RightLeg/Anim.play("Idle")
	else:
		$LeftLeg/Anim.play("Idle")
		$RightLeg/Anim.play("Idle")
	
	if Input.is_key_pressed(KEY_X) && fireCooldown < 0 && energy > primaryEnergyUse:
		energy -= primaryEnergyUse
		fireCooldown = primaryFireInterval
		fireCount += 1
		
		var p = [$GunLeft, $GunRight][fireCount%2]
		
		var l = beam.instance()
		l.vel = vel + vector_up * 512
		get_parent().add_child(l)
		l.set_global_transform(p.get_global_transform())
		l.rotation_degrees = rotation_degrees - 90
	if Input.is_key_pressed(KEY_Z) && fireCooldown < 0 && energy > secondaryEnergyUse:
		energy -= secondaryEnergyUse
		fireCooldown = secondaryFireInterval
		$Anim.play("Cast")
func _physics_process(delta):
	global_translate(vel * delta)
	rotation_degrees += turn * delta
func fire_beam():
	var p = [$GunLeft, $GunRight][fireCount%2]
	fireCount += 1
	var l = beam.instance()
	var vector_up = -get_global_transform().orthonormalized().y
	l.vel = vel + vector_up * 512
	get_parent().add_child(l)
	l.set_global_transform(p.get_global_transform())
	l.rotation_degrees = rotation_degrees - 90
	
func fire_blast():
	var p = $BeamOrigin
	var l = blast.instance()
	var vector_up = -get_global_transform().orthonormalized().y
	l.vel = vel + vector_up * 750
	get_parent().add_child(l)
	l.set_global_transform(p.get_global_transform())
	l.rotation_degrees = rotation_degrees - 90


func _on_body_animation_finished(name):
	if name == "Cast":
		$Anim.play("Idle")
