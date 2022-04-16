extends Sprite

var target
func _on_area_entered(area):
	var p = area.get_parent()
	if p.is_in_group("Player"):
		target = p
func _process(delta):
	if target != null:
		# FIX ANGLE BUG
		var offset = target.global_position - global_position
		offset = offset.angle() - rotation
		if offset > PI:
			offset -= 2 * PI
		if offset < -PI:
			offset += PI * 2
			
		var speed = PI / 90
		offset = offset / 30
		if abs(offset) > speed:
			offset = sign(offset) * speed
		rotation += offset
