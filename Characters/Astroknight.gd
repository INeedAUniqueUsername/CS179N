extends Sprite

onready var vel = Vector2(0, 0)
onready var turn = 0

onready var hp = 100
onready var energy = 100

const primaryFireInterval = 0.5
const secondaryFireInterval = 2
const primaryEnergyUse = 10
const secondaryEnergyUse = 50

# time remaining before weapon is ready
# if negative, indicates excess time that has passed (used for battery recharge)
var fireCooldown = 0

const beam = preload("res://SwordBeam.tscn")

func _process(delta):
	fireCooldown -= delta
	if fireCooldown < 0:
		var rechargeRate = 20 - fireCooldown*5
		energy = min(100, energy + delta * rechargeRate)
	
	var vector_up = -get_global_transform().orthonormalized().y
	if $AnimationPlayer.current_animation == "Slash":
		vel += vector_up * delta * 240
		return
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
	
	if Input.is_key_pressed(KEY_X) && fireCooldown < 0 && energy > primaryEnergyUse:
		energy -= primaryEnergyUse
		fireCooldown = primaryFireInterval
		
		for p in [$GunLeft, $GunRight]:
			var l = beam.instance()
			l.vel = vel + vector_up * 512
			get_parent().add_child(l)
			l.set_global_transform(p.get_global_transform())
			l.rotation_degrees = rotation_degrees - 90
	if Input.is_key_pressed(KEY_Z) && fireCooldown < 0 && energy > secondaryEnergyUse:
		energy -= secondaryEnergyUse
		fireCooldown = secondaryFireInterval
		$AnimationPlayer.play("Slash")
func _physics_process(delta):
	global_translate(vel * delta)
	rotation_degrees += turn * delta
