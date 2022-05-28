extends Enemies
const score = 100
var moveSpeed = 50
var vel = Vector2(0, 0)

var base_cooldown = 2
var curr_cooldown = 0

var beamSpeed = 250

var ignore = [self]
const beam = preload("res://Missile.tscn")

func _ready():
	if PlayerVariables.difficulty == 0:
		hp = 50
	elif PlayerVariables.difficulty == 1:
		hp = 100
	elif PlayerVariables.difficulty == 2:
		hp = 150

func _physics_process(delta):
	global_translate(vel * delta)
	
	curr_cooldown -= delta
	# Send a beam every second
	if atk_target != null and curr_cooldown < 0 and ignore_target <= 0:
		curr_cooldown = base_cooldown

		var beam_load = beam.instance()
		beam_load.vel = forward * beamSpeed
		beam_load.ignore = [self, beam_load]
		beam_load.target = atk_target

		get_parent().add_child(beam_load)
		beam_load.set_global_transform(get_global_transform())
		beam_load.rotation_degrees = rotation_degrees
		$Attack.play()

func _process(delta):
	var destVel = forward * moveSpeed
	var velDiff = destVel - vel
	vel += velDiff.normalized() * min(velDiff.length(), 120 * delta)
	
	# Patrols in a square formation turning every 2 seconds when no target in sight
	if target == null:
		rotate(delta * PI/3)
	if ignore_target > 0:
		ignore_target -= delta
