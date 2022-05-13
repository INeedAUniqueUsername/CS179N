extends Enemies
const score = 20
var moveSpeed = 50
var vel = Vector2(0, 0)

var base_cooldown = 2
var curr_cooldown = 0

var beamSpeed = 250

const beam = preload("res://Missile.tscn")
func _physics_process(delta):
	global_translate(vel * moveSpeed * delta)
	
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
var patrol_time = 2
var curr_patrol_time = 0
func _process(delta):
	vel = forward
	
	# Patrols in a square formation turning every 2 seconds when no target in sight
	if target == null:
		curr_patrol_time -= delta
		if curr_patrol_time < 0:
			curr_patrol_time = patrol_time
			rotate(PI/2)
	if ignore_target > 0:
		ignore_target -= delta
