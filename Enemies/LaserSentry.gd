extends Enemies
const score = 100

var base_cooldown = 1.5
var curr_cooldown = 0

var vel = Vector2(0, 0)

enum sentry {Laser, Missile}
export (sentry) var sentryType

var beam
var beamSpeed
onready var ignore = [self, $Shield, $Mount, $Gun/Shield]
func _ready():
	if PlayerVariables.difficulty == 0:
		hp = 50
	elif PlayerVariables.difficulty == 1:
		hp = 100
	elif PlayerVariables.difficulty == 2:
		hp = 150
	self.body = $Gun
	self.connect("on_destroyed", self, "on_sentry_destroyed")
	
	match sentryType:
		sentry.Laser:
			beam = preload("res://LaserBeam.tscn")
			beamSpeed = 400
		sentry.Missile:
			beam = preload("res://Missile.tscn")
			beamSpeed = 250
		_:
			print("Error: Invalid Sentry Type")

func on_sentry_destroyed(a):
	for s in [$Shield, $Gun/Shield]:
		if s:
			s.destroy()
func _physics_process(delta):
	curr_cooldown -= delta
	
	vel -= vel.normalized() * min(vel.length(), 360 * delta)
	global_translate(vel * delta)
	# Send a beam every second
	if atk_target != null and curr_cooldown < 0 and ignore_target <= 0:
		curr_cooldown = base_cooldown

		var beam_load = beam.instance()
		beam_load.vel = forward * beamSpeed

		beam_load.ignore = ignore
		ignore.append(beam_load)
		
		if sentryType == sentry.Missile:
			beam_load.target = atk_target

		get_parent().add_child(beam_load)
		beam_load.global_position = $Gun/BeamOrigin.global_position
		beam_load.global_rotation = $Gun.global_rotation

func _process(delta):
	if ignore_target > 0:
		ignore_target -= delta

