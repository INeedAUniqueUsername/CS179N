extends Sprite


var vel = Vector2(0, 0)
func _process(delta):
	pass
var hp = 300
var hp_max = 300
func damage(projectile):
	hp = max(0, hp - projectile.damage)
	if hp == 0:
		destroy()
signal on_destroyed(Node2D)
func destroy():
	emit_signal("on_destroyed", self)
	queue_free()
var damage = 20
func _on_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		actor.damage(self)
