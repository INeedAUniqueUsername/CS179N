class_name Common
var vel = Vector2(0, 0)
var turn = 0

var hp = 100
var energy = 100
var fuel = 100

var fuelUsage = 1.0/90
var thrustSpeed = 240
var turnSpeed = 180

var owner

var animBody
var animLeftLeg
var animRightLeg

# time remaining before weapon is ready
# if negative, indicates excess time that has passed (used for battery recharge)
var fireCooldown = 0

func canFire(): return fireCooldown < 0

func _init(owner: Node2D, animBody: AnimationPlayer, animLeftLeg: AnimationPlayer, animRightLeg: AnimationPlayer):
	self.owner = owner
	self.animBody = animBody
	self.animLeftLeg = animLeftLeg
	self.animRightLeg = animRightLeg
func update_physics(delta):
	owner.global_translate(vel * delta)
	owner.rotation_degrees += turn * delta
	vector_up = -owner.get_global_transform().orthonormalized().y
	if decel_vel:
		vel -= vel.normalized() * min(vel.length(), thrustSpeed * delta)
	if decel_turn:
		turn -= sign(turn) * min(abs(turn), 16 * turnSpeed * delta)
	
var decel_vel
var decel_turn
func update_systems(delta):
	damageDelay -= delta
	fireCooldown -= delta
	if fireCooldown < 0:
		var rechargeRate = 10 - fireCooldown*5
		var inc = min(100 - energy, delta * rechargeRate)
		if inc >= 0:
			energy += inc
			fuel -= inc / 90
var damageDelay = 0
func damage(attacker):
	if damageDelay > 0:
		return
	var d = attacker.damage
	hp = max(0, hp - d)
	damageDelay = 1
var vector_up
func thrust(dest_vel):
	
	var rejection = vel * (1 - vel.normalized().dot(dest_vel.normalized()))
	
	vel -= rejection.normalized() * min(rejection.length(), thrustSpeed / 10) 
	vel += (dest_vel - vel).normalized() * min(thrustSpeed / 10, (dest_vel - vel).length())
	
	decel_vel = false
func turn(dest_turn, delta):
	if sign(dest_turn) == sign(turn):
		if abs(dest_turn) > abs(turn):
			turn += sign(dest_turn) * min(60, abs(dest_turn - turn))
	else:
		turn += sign(dest_turn) * min(60, abs(dest_turn - turn))
	
	decel_turn = false
func update_controls(delta):
	var up = Input.is_key_pressed(KEY_UP)
	var left = Input.is_key_pressed(KEY_LEFT)
	var right = Input.is_key_pressed(KEY_RIGHT)
	
	decel_vel = true
	decel_turn = true
	if up:
		fuel -= fuelUsage
		if left == right:
			thrust(vector_up * thrustSpeed)
			
			animLeftLeg.play("Thrust")
			animRightLeg.play("Thrust")
		elif left:
			turn(-turnSpeed, delta)
			thrust(vector_up * thrustSpeed * 3/4)
			animLeftLeg.play("Thrust")
			animRightLeg.play("Turn")
		elif right:
			turn(turnSpeed, delta)
			thrust(vector_up * thrustSpeed * 3/4)
			animLeftLeg.play("Turn")
			animRightLeg.play("Thrust")
	elif left and right:
		fuel -= fuelUsage
		thrust(vector_up * thrustSpeed)
		animLeftLeg.play("Turn")
		animRightLeg.play("Turn")
	elif left:
		fuel -= fuelUsage / 2
		turn(-turnSpeed, delta)
		animLeftLeg.play("Idle")
		animRightLeg.play("Turn")
	elif right:
		fuel -= fuelUsage / 2
		turn(turnSpeed, delta)
		animLeftLeg.play("Turn")
		animRightLeg.play("Idle")
	else:
		animLeftLeg.play("Idle")
		animRightLeg.play("Idle")
