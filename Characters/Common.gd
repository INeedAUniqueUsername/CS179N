var owner

var vel = Vector2(0, 0)
var turn = 0

var hp = 100
var energy = 100
var fuel = 100

var fuelUsage = 1.0/90
var thrustSpeed = 240
var turnSpeed = 180

var animBody
var animLeftLeg
var animRightLeg

var fireCooldown = 0

func update_energy(delta):
	fireCooldown -= delta
	if fireCooldown < 0:
		var rechargeRate = 10 - fireCooldown*5
		var inc = min(100 - energy, delta * rechargeRate)
		if inc >= 0:
			energy += inc
			fuel -= inc / 90
func update_controls(delta):
	
	var up = Input.is_key_pressed(KEY_UP)
	var left = Input.is_key_pressed(KEY_LEFT)
	var right = Input.is_key_pressed(KEY_RIGHT)
	
	var fuelUsage = 1.0/90
	var thrustSpeed = 240
	var turnSpeed = 180
	
	var vector_up = -owner.get_global_transform().orthonormalized().y
	if up:
		fuel -= fuelUsage
		if left == right:
			vel += vector_up * delta * thrustSpeed
			animLeftLeg.play("Thrust")
			animRightLeg.play("Thrust")
		elif left:
			turn -= delta * turnSpeed / 2
			vel += vector_up * delta * thrustSpeed * 3/4
			animLeftLeg.play("Thrust")
			animRightLeg.play("Turn")
		elif right:
			turn += delta * turnSpeed / 2
			vel += vector_up * delta * thrustSpeed * 3/4
			animLeftLeg.play("Turn")
			animRightLeg.play("Thrust")
	elif left and right:
		fuel -= fuelUsage
		vel += vector_up * delta * thrustSpeed
		animLeftLeg.play("Turn")
		animRightLeg.play("Turn")
	elif left:
		fuel -= fuelUsage / 2
		turn -= delta * turnSpeed
		animLeftLeg.play("Idle")
		animRightLeg.play("Turn")
	elif right:
		fuel -= fuelUsage / 2
		turn += delta * turnSpeed
		animLeftLeg.play("Turn")
		animRightLeg.play("Idle")
	else:
		animLeftLeg.play("Idle")
		animRightLeg.play("Idle")
