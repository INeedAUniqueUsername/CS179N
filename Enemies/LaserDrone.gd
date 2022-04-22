extends Enemies

var moveSpeed = 50
var vel = Vector2(0, 0)

func _physics_process(delta):
	global_translate(vel * moveSpeed * delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target != null:
		vel = forward
	else:
		vel = Vector2(0, 0)
