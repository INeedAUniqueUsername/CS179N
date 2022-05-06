extends Enemies

var moveSpeed = 50

var base_cooldown = 1
var curr_cooldown = 0

const beam = preload("res://LaserBeam.tscn")
var beamSpeed = 400
func _physics_process(delta):
	curr_cooldown -= delta
	# Send a beam every second
	if atk_target != null and curr_cooldown < 0 and ignore_target <= 0:
		curr_cooldown = base_cooldown

		var beam_load = beam.instance()
		beam_load.vel = forward * beamSpeed

		beam_load.ignore = [self, beam_load]

		get_parent().add_child(beam_load)
		beam_load.set_global_transform(get_global_transform())
		beam_load.rotation_degrees = rotation_degrees

func _process(delta):
	if ignore_target > 0:
		ignore_target -= delta
