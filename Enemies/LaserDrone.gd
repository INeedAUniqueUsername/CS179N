extends Enemies

const beam = preload("res://LaserBeam.tscn")

var moveSpeed = 50
var vel = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var vector_up
func _physics_process(delta):
	self.global_translate(vel * moveSpeed * delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target != null:
		vel = -get_global_transform().orthonormalized().y
	else:
		vel = Vector2(0, 0)
