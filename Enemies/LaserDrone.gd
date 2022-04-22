extends Enemies

var moveSpeed = 50
var vel = Vector2(0, 0)

var base_cooldown = 1.5
var curr_cooldown = 0
func _physics_process(delta):
	global_translate(vel * moveSpeed * delta)
	
	curr_cooldown -= delta
	# Send a beam every 3 seconds
	if atk_target != null and curr_cooldown < 0:
		curr_cooldown = base_cooldown
		var beam_load = beam.instance()
		beam_load.vel = forward * beamSpeed
		get_parent().add_child(beam_load)
		beam_load.set_global_transform(get_global_transform())
		beam_load.rotation_degrees = rotation_degrees - 90

# Triggered when player enter's enemy's attack radius
const beam = preload("res://LaserBeam.tscn")
var atk_target
func _on_Attack_Area_body_entered(body):
	if body.is_in_group("Player"):
		atk_target = body
		
# Triggered when player exits enemy's attack radius
func _on_Attack_Area_body_exited(body):
	if body.is_in_group("Player"):
		atk_target = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target != null:
		vel = forward
	else:
		vel = Vector2(0, 0)