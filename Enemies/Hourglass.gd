extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	turn()
	pass # Replace with function body.
func _process(delta):
	for actor in nearby:
		var sc = max(0.01, (actor.global_position - global_position).length() / $TimeSlow/CollisionShape2D.shape.radius)
		actor.set_time_scale(sc)

func _physics_process(delta):
	global_translate(vel * delta)
	#vel -= vel.normalized() * min(vel.length(), 120 * delta)
	turnTime -= delta
	if turnTime < 0:
		turn()
var vel : Vector2 = polar2cartesian(120, rand_range(0, PI*2))
var turnTime : float
func turn():
	turnTime = 5
	vel = vel.rotated(rand_range(-PI/2, PI/2))
func damage(projectile):
	pass
var nearby = []
func canSlow(area):
	if !Helper.is_area_body(area):
		return null
	var actor = Helper.get_parent_actor(area)
	if actor and !actor.is_in_group("Magic") and actor.has_method("set_time_scale"):
		return actor
	return null
func _on_TimeSlow_area_entered(area):
	var actor = canSlow(area)
	if actor:
		actor.set_time_scale(1)
		nearby.append(actor)
		#if actor.is_in_group("Player"):
			#vel = 120 * (actor.global_position - global_position).normalized()


func _on_TimeSlow_area_exited(area):
	var actor = canSlow(area)
	if actor:
		nearby.erase(actor)
		actor.set_time_scale(1)
