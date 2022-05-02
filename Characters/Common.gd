class_name Common
var vel = Vector2(0, 0)
var turn = 0

var hp = 100
var energy = 100
var fuel = 100
var levelTime = 0.0
var levelScore = 0.0

var fuelUsage = 1.0/2
var thrustSpeed = 600
var turnSpeed = 720

var owner

var animBody
var animLeftLeg
var animRightLeg

# time remaining before weapon is ready
# if negative, indicates excess time that has passed (used for battery recharge)
var fireCooldown = 0

func canFire(): return fireCooldown < 0

var time_scale = 1
func set_time_scale(t):
	time_scale = t
	animBody.playback_speed = t
	animLeftLeg.playback_speed = t
	animRightLeg.playback_speed = t

func _init(owner: Node2D, animBody: AnimationPlayer, animLeftLeg: AnimationPlayer, animRightLeg: AnimationPlayer):
	self.owner = owner
	self.animBody = animBody
	self.animLeftLeg = animLeftLeg
	self.animRightLeg = animRightLeg
	

func update_physics(delta):
	levelTime += delta
	delta *= time_scale
	owner.global_translate(vel * delta)
	owner.rotation_degrees += turn * delta
	vector_up = -owner.get_global_transform().orthonormalized().y
	if decel_vel:
		vel -= delta * vel.normalized() * min(vel.length() * 2, thrustSpeed * 2)
	if decel_turn:
		turn -= delta * sign(turn) * min(abs(turn) * 15, 16 * turnSpeed)
signal on_fuel_warning
signal on_fuel_depleted
var decel_vel
var decel_turn
var prevFuel = 100
func update_systems(delta):
	delta *= time_scale
	
	if state == State.Recovering:
		fuel = max(0, fuel - delta * 5)
		if fuel == 0:
			emit_signal("on_fuel_depleted", self)
		return
	elif state != State.Active:
		return
	
	damageDelay -= delta
	fireCooldown -= delta
	if fireCooldown < 0:
		var rechargeRate = 10 - fireCooldown*5
		var inc = min(100 - energy, delta * rechargeRate)
		if inc > 0:
			energy += inc
			fuel -= inc / 60.0
	if damageDelay < 0:
		var rechargeRate = 0.75 * (1 - damageDelay)
		var inc = min(100 - hp, delta * rechargeRate)
		if inc > 0:
			hp += inc
			fuel -= inc / 20.0
	if fuel == 0:
		emit_signal("on_fuel_depleted", self)
	elif fuel < 30 and prevFuel > 30:
		emit_signal("on_fuel_warning", self)
	prevFuel = fuel
signal on_mortal
signal on_destroyed
var mortalChances = 3
var damageDelay = 0

enum State {
	Active, Recovering, Dead, Winner
}
var state = State.Active
func damage(attacker):
	if state != State.Active:
		return
	if damageDelay > 0:
		return
	hp = max(0, hp - attacker.damage)
	if 'drain' in attacker:
		energy = max(0, energy - attacker.drain)
		fireCooldown = max(0, fireCooldown)
	damageDelay = 1
	
	if hp == 0:
		if mortalChances > 0:
			mortalChances -= 1
			emit_signal("on_mortal", owner)
			var t = Timer.new()
			t.wait_time = 6
			t.connect("timeout", self, "recover")
			t.connect("timeout", t, "queue_free")
			owner.add_child(t)
			t.start()
			state = State.Recovering
			
			animLeftLeg.play("Idle")
			animRightLeg.play("Idle")
		else:
			emit_signal("on_destroyed", owner)
			state = State.Dead
			
func recover():
	hp = 100
	state = State.Active
var vector_up
func thrust(dest_vel, delta):
	var rejection = vel * (1 - vel.normalized().dot(dest_vel.normalized()))
	
	vel -= delta * rejection.normalized() * min(rejection.length(), thrustSpeed) 
	vel += delta * (dest_vel - vel).normalized() * min(thrustSpeed, (dest_vel - vel).length())
	
	decel_vel = false
func turn(dest_turn, delta):
	if sign(dest_turn) == sign(turn):
		if abs(dest_turn) > abs(turn):
			turn += delta * sign(dest_turn) * min(turnSpeed, abs(dest_turn - turn))
	else:
		turn += delta * sign(dest_turn) * min(turnSpeed, abs(dest_turn - turn))
	
	decel_turn = false
func consume_fuel(f):
	fuel = max(0, fuel - f)
func update_controls(delta):
	delta *= time_scale
	
	match state:
		State.Recovering, State.Dead:
			decel_vel = false
			decel_turn = false
			return
		State.Winner:
			decel_vel = true
			decel_turn = true
			animLeftLeg.play("Idle")
			animRightLeg.play("Idle")
			return
	var up = Input.is_key_pressed(KEY_UP)
	var left = Input.is_key_pressed(KEY_LEFT)
	var right = Input.is_key_pressed(KEY_RIGHT)
	
	decel_vel = true
	decel_turn = true
	if up:
		consume_fuel(delta * fuelUsage)
		if left == right:
			thrust(vector_up * thrustSpeed, delta)
			
			animLeftLeg.play("Thrust")
			animRightLeg.play("Thrust")
		elif left:
			turn(-turnSpeed, delta)
			thrust(vector_up * thrustSpeed * 3/4, delta)
			animLeftLeg.play("Thrust")
			animRightLeg.play("Turn")
		elif right:
			turn(turnSpeed, delta)
			thrust(vector_up * thrustSpeed * 3/4, delta)
			animLeftLeg.play("Turn")
			animRightLeg.play("Thrust")
	elif left and right:
		consume_fuel(delta * fuelUsage)
		thrust(vector_up * thrustSpeed, delta)
		animLeftLeg.play("Turn")
		animRightLeg.play("Turn")
	elif left:
		consume_fuel(delta * fuelUsage / 2)
		turn(-turnSpeed, delta)
		animLeftLeg.play("Idle")
		animRightLeg.play("Turn")
	elif right:
		consume_fuel(delta * fuelUsage / 2)
		turn(turnSpeed, delta)
		animLeftLeg.play("Turn")
		animRightLeg.play("Idle")
	else:
		animLeftLeg.play("Idle")
		animRightLeg.play("Idle")
