extends Enemies
const score = 100

var base_cooldown = 1.5
var curr_cooldown = 0

var vel = Vector2(0, 0)
const beam = preload("res://LaserBeam.tscn")
var beamSpeed = 400
onready var ignore = [self, $Shield, $Mount, $Gun/Shield]
func _ready():
	self.body = $Gun
	self.connect("on_destroyed", self, "on_sentry_destroyed")
func on_sentry_destroyed(a):
	$Shield.destroy()
	$Gun/Shield.destroy()
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

		get_parent().add_child(beam_load)
		beam_load.global_position = $Gun/BeamOrigin.global_position
		beam_load.global_rotation = $Gun.global_rotation

func _process(delta):
	if ignore_target > 0:
		ignore_target -= delta
