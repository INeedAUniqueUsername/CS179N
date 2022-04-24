extends Node2D

var vel = Vector2(0, 0)
var hp = 100
signal on_destroyed
func _on_area_entered(area):
	var actor = Helper.get_parent_actor(area)
	
func damage(projectile):
	hp = max(hp - projectile.damage, 0)
	if hp == 0:
		emit_signal("on_destroyed", self)
		queue_free()
