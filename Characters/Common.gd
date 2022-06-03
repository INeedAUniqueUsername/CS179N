class_name Common
var vel = Vector2(0, 0)
var turn = 0

var hp_max = 100
var energy_max = 100
var fuel_max = 100
var hp = hp_max
var energy = energy_max
var fuel = fuel_max
var levelTime = 0.0
var levelScore = 0.0

var fuelUsage = 1/2.0
var thrustSpeed = 600
var turnSpeed = 720

var owner

var animBody
var animLeftLeg
var animRightLeg

# time remaining before weapon is ready
# if negative, indicates excess time that has passed (used for battery recharge)
var fireCooldown = 0



# restores back to 1.0 over time
var time_factor = 1.0
func set_time_factor(t):
	time_factor = min(t, time_factor)
func inc_time_factor(t):
	time_factor = max(0, time_factor + t)



func canFire(): return fireCooldown < 0

var time_scale = 1
func set_time_scale(t):
	time_scale = t
	animBody.playback_speed = t
	animLeftLeg.playback_speed = t
	animRightLeg.playback_speed = t

func is_control_pressed(k):
	var b = Input.is_key_pressed(k)
	if k in buttons.keys():
		b = b or buttons[k].is_pressed()
	return b

var buttons : Dictionary
func _init(owner: Node2D, animBody: AnimationPlayer, animLeftLeg: AnimationPlayer, animRightLeg: AnimationPlayer):
	self.owner = owner
	self.animBody = animBody
	self.animLeftLeg = animLeftLeg
	self.animRightLeg = animRightLeg
	owner.connect("tree_entered", self, "register_buttons")
func register_buttons():
	buttons = {
		KEY_UP: owner.get_node("../../Camera2D/Control/Arrows/Up"),
		KEY_RIGHT: owner.get_node("../../Camera2D/Control/Arrows/Right"),
		KEY_LEFT: owner.get_node("../../Camera2D/Control/Arrows/Left"),
		KEY_DOWN: owner.get_node("../../Camera2D/Control/Arrows/Down"),
		KEY_X: owner.get_node("../../Camera2D/Control/Keys/X"),
		KEY_Z: owner.get_node("../../Camera2D/Control/Keys/Z"),
	}

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
signal on_fuel_warning(Node2D)
signal on_fuel_depleted(Node2D)
var decel_vel
var decel_turn
onready var prevFuel = fuel_max
func update_systems(delta):
	
	#hp = hp_max
	#energy = energy_max
	#vel = Vector2(0, 0)
	delta *= time_scale
	if state == State.Recovering:
		fuel = max(0, fuel - delta * 5)
		if fuel == 0:
			energy = 0
			emit_signal("on_fuel_depleted", self)
			state = State.Dead
		return
	elif state == State.Dying:
		if energy > 0:
			energy = max(0, energy - delta * 20)
		else:
			hp = max(0, hp - delta * 20)
			if hp == 0:
				emit_signal("on_fuel_depleted", self)
				state = State.Dead
		return
	elif state != State.Active:
		return
	
	damageDelay -= delta
	fireCooldown -= delta
	if fireCooldown < 0:
		var rechargeRate = (-fireCooldown * 5 + 10) * rechargeFactor
		var inc = min(energy_max - energy, delta * rechargeRate)
		if inc > 0:
			energy += inc
			fuel -= inc / 60.0
	if damageDelay < 0:
		var rechargeRate = 0.75 * (1 - damageDelay) * rechargeFactor
		var inc = min(hp_max - hp, delta * rechargeRate)
		if inc > 0:
			hp += inc
			fuel -= inc / 20.0
	if fuel == 0:
		emit_signal("on_fuel_depleted", self)
		state = State.Dying
	elif fuel < 40 and prevFuel > 40:
		emit_signal("on_fuel_warning", self)
	prevFuel = fuel
signal on_mortal
signal on_destroyed
var damageDelay = 0
enum State {
	Active, Recovering, Dying, Dead, Winner
}
signal on_recovered(Node2D)
var state = State.Active
var lastDamage = 0
var lastDrain = 0
func damage(attacker):
	if state != State.Active:
		return
	var atk_dmg = attacker.damage
	var Modes = PlayerVariables.DifficultyModes
	match PlayerVariables.difficulty:
		Modes.Easy:
			atk_dmg *= 0.5
		Modes.Medium:
			atk_dmg *= 1.0
		Modes.Hard:
			atk_dmg *= 2.0
	if damageDelay > 0:
		var inc = atk_dmg - lastDamage
		if inc > 0:
			hp = max(0, hp - inc)
			lastDamage = atk_dmg
		else:
			return
	else:
		hp = max(0, hp - atk_dmg)
		lastDamage = atk_dmg
		if 'drain' in attacker:
			energy = max(0, energy - attacker.drain)
			lastDrain = attacker.drain
			fireCooldown = max(0, fireCooldown)
		damageDelay = 1
	if hp == 0:
		emit_signal("on_mortal", owner)
		var t = Timer.new()
		t.wait_time = 6
		owner.add_child(t)
		t.start()
		state = State.Recovering
		animLeftLeg.play("Idle")
		animRightLeg.play("Idle")
		
		yield(t, "timeout")
		t.queue_free()
		if state == State.Dead:
			return
		#change to hp_max
		hp = hp_max
		state = State.Active
		emit_signal("on_recovered", self)
func resurrect():
	state = State.Active
	hp = hp_max
	energy = energy_max
	fuel = fuel_max
	emit_signal("on_recovered", self)
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
	
var rechargeFactor = fuel_max / 100.0
func add_fuel(f, fm):
	fuel_max += fm
	fuel = min(fuel_max, fuel + f)
	rechargeFactor = fuel_max / 100.0
	print(fuel)
	print(fuel_max)
	
func add_hp(h, hm):
	hp_max += hm
	hp = min(hp_max, hp + h)
	print(hp)
	print(hp_max)
	
func add_energy(e, em):
	energy_max += em
	energy = min(energy_max, energy + e)
	print(energy)
	print(energy_max)
	
func update_controls(delta):
	delta *= time_scale
	
	#for k in [KEY_UP, KEY_RIGHT, KEY_LEFT, KEY_DOWN, KEY_X, KEY_Z]:
	#	buttons[k].pressed = Input.is_key_pressed(k)
	
	match state:
		State.Recovering, State.Dead, State.Dying:
			decel_vel = false
			decel_turn = false
			animLeftLeg.play("Idle")
			animRightLeg.play("Idle")
			return
		State.Winner:
			decel_vel = true
			decel_turn = true
			animLeftLeg.play("Idle")
			animRightLeg.play("Idle")
			return
	var up = is_control_pressed(KEY_UP)
	var left = is_control_pressed(KEY_LEFT)
	var right = is_control_pressed(KEY_RIGHT)
	var down = is_control_pressed(KEY_DOWN)
	
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
		
	if down:
		decel_turn = false
		decel_vel = false
