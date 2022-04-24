extends Node2D


signal on_destroyed
func _on_area_entered(area):
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		emit_signal("on_destroyed", self)
		$Area.queue_free()
		$Anim.play("Fade")
