extends Sprite

var target = null

var distance2 = INF
onready var radius2 = $Area/Circle.shape.radius * $Area/Circle.shape.radius
func _process(delta):
	if target:
		distance2 = (target.global_position - global_position).length_squared()
		modulate.a = max(0, min(1, distance2 / radius2))
	else:
		modulate.a = min(1, modulate.a + 1 / 30.0)
func _on_area_entered(area):
	var actor = Helper.get_actor_of_body(area)
	if actor and actor.is_in_group("Player") and !target:
		target = actor
func _on_area_exited(area):
	var actor = Helper.get_actor_of_body(area)
	if actor and actor.is_in_group("Player") and target == actor:
		target = null
