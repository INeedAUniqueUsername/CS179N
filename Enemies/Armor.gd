extends Sprite

var parent
func _ready():
	parent = Helper.get_root_actor(self)
var vel setget set_vel, get_vel
func set_vel(v):
	parent.vel = v
func get_vel():
	return parent.vel
signal on_destroyed
export(int) var hp = 600
func damage(projectile):
	hp = max(0, hp - projectile.damage)
	if hp == 0:
		destroy()
func destroy():
	emit_signal("on_destroyed", self)
	queue_free()

export(bool) var blockPlayer = false

func _on_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if !actor:
		return
	var n = actor.name
	if actor.is_in_group("Projectile"):
		if actor.ignore.has(self):
			return
		damage(actor)
		if actor.is_in_group("Magic"):
			return
		actor.ignore = parent.ignore
		
		var velDiff = get_vel() - actor.vel
		actor.vel = get_vel() + velDiff
	elif actor.is_in_group("Player") and blockPlayer:
		var velDiff = self.vel - actor.common.vel
		actor.common.vel += velDiff
		self.vel -= velDiff/2
