extends Sprite

onready var hp = 100
onready var vel = Vector2(0, 0)
onready var turn = 0

var idle = preload("res://Sprites/StarmanIdle.png")
var thrust = preload("res://Sprites/StarmanThrust.png")
var turnLeft = preload("res://Sprites/StarmanTurnLeft.png")
var turnRight = preload("res://Sprites/StarmanTurnRight.png")

var fireInterval = 0.4
var fireCooldown = 0.4
var laser = preload("res://LaserBeam.tscn")
func _process(delta):
	var vector_up = -get_global_transform().orthonormalized().y
	var up = Input.is_key_pressed(KEY_UP)
	var left = Input.is_key_pressed(KEY_LEFT)
	var right = Input.is_key_pressed(KEY_RIGHT)
	if up or (left and right):
		vel += vector_up * delta * 240
		texture = thrust
		pass
	elif left:
		texture = turnLeft
		turn -= 180 * delta
	elif right:
		texture = turnRight
		turn += 180 * delta
	else:
		texture = idle
	
	fireCooldown -= delta
	if Input.is_key_pressed(KEY_X) && fireCooldown < 0:
		fireCooldown = fireInterval
		for p in [$GunLeft, $GunRight]:
			var l = laser.instance()
			l.vel = vel + vector_up * 2048
			get_parent().add_child(l)
			l.set_global_transform(p.get_global_transform())
			l.rotation_degrees = rotation_degrees + 90
		
		
func _physics_process(delta):
	global_translate(vel * delta)
	rotation_degrees += turn * delta
