extends Timer

onready var parent = get_parent()
onready var quadVel = polar2cartesian(240, (randi() % 4) * PI / 2.0)
func _ready():
	call_deferred("apply_vel")
func apply_vel():
	parent.vel += quadVel
func on_interval():
	parent.vel -= quadVel
	quadVel = quadVel.rotated(((randi() % 3) - 1) * PI / 2)
	parent.vel += quadVel
		
