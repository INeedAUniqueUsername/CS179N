extends Sprite

var vel setget set_vel, get_vel
func set_vel(v):
	Helper.get_parent_actor(self.get_parent()).vel = v
func get_vel():
	return Helper.get_parent_actor(self.get_parent()).vel
signal on_destroyed
export(int) var hp = 600
func damage(projectile):
	hp = max(0, hp - projectile.damage)
	if hp < 1:
		destroy()
func destroy():
	emit_signal("on_destroyed", self)
	queue_free()
var reflected = []
func _on_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Projectile"):
		if actor.ignore.has(self):
			return
		damage(actor)
		if reflected.has(actor):
			return
		reflected.append(actor)
		if actor.is_in_group("Magic"):
			return
		var ignore = [self, Helper.get_parent_actor(get_parent())]
		actor.ignore = ignore
		
		var velDiff = get_vel() - actor.vel
		actor.vel = get_vel() + velDiff
