extends Sprite

var root
func _ready():
	root = Helper.get_root_actor(self)
	var p = Helper.get_parent_actor(get_parent())
	p.connect("on_destroyed", self, "on_parent_destroyed")
func on_parent_destroyed(p):
	destroy()
var vel setget set_vel, get_vel
func set_vel(v):
	root.vel = v
func get_vel():
	return root.vel
signal on_destroyed
export(int) var hp = 600
func damage(projectile):
	hp = max(0, hp - projectile.damage)
	if hp == 0:
		destroy()
var destroyed = false
func destroy():
	if destroyed:
		return
	destroyed = true
	emit_signal("on_destroyed", self)
	queue_free()

export(bool) var blockPlayer = false
export(int) var playerDamage = 0
var damage = 0

func _on_area_entered(area):
	var actor = Helper.get_actor_of_body(area)
	if !actor or root.ignore.has(actor):
		return
	var n = actor.name
	if actor.is_in_group("Projectile"):
		if actor.ignore.has(self):
			return
		damage(actor)
		if actor.is_in_group("Magic"):
			return
		actor.ignore = root.ignore
		
		var velDiff = get_vel() - actor.vel
		actor.vel = get_vel() + velDiff
	elif actor.is_in_group("Player"):
		if blockPlayer:
			var velDiff = self.vel - actor.common.vel
			actor.common.vel += velDiff
			self.vel -= velDiff/2
	if playerDamage > 0:
		damage = playerDamage
		actor.damage(self)
