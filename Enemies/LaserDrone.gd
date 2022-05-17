extends Enemies
const score = 100
var moveSpeed = 50
var vel = Vector2(0, 0)

var base_cooldown = 1
var curr_cooldown = 0

const beam = preload("res://LaserBeam.tscn")
var beamSpeed = 400
func _ready():
	hp = 80
func _physics_process(delta):
	delta *= self.time_scale
	global_translate(vel * delta)
	
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
		$LaserDroneFireSound.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	delta *= self.time_scale
	var destVel = forward * moveSpeed
	var velDiff = destVel - vel
	vel += velDiff.normalized() * min(velDiff.length(), 120 * delta)
	
	
	
	
	# Patrols in a square formation turning every 2 seconds when no target in sight
	if !target:
		rotate(delta * PI/3)
	if ignore_target > 0:
		ignore_target -= delta
