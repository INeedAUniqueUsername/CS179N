extends Sprite
var hp = 60
var hp_max = 60

var damageDelay = 0
var vel : Vector2 setget set_vel, get_vel
onready var main : Node2D = get_parent()
onready var parent : Node2D = main.get_parent()
func get_vel():
	return parent.vel
func set_vel(vel):
	parent.vel = vel
func _ready():
	$Area.connect("area_entered", self, "on_area_entered")
	$Area.connect("area_exited", self, "on_area_exited")
var hit = []
func on_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	
	if main.ignore.has(actor):
		return
	hit.append(actor)
	main.ignore.append(actor)
	
	if actor and actor.is_in_group("Player"):
		var velDiff = vel - actor.vel
		actor.common.vel += velDiff
		parent.vel -= velDiff
func on_area_exited(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	
	if hit.has(actor):
		main.ignore.erase(actor)
	
func _process(delta):
	damageDelay -= delta
	if damageDelay < 0:
		hp = min(hp_max, hp + delta * 50)
		var a = $Area
		a.monitorable = hp > 0
		a.monitoring = hp > 0
	modulate.a = 1.0 * hp / hp_max
func damage(projectile):
	if hp == 0:
		if projectile.is_in_group("Projectile"):
			projectile.pierce += 1
		return
	hp = max(0, hp - projectile.damage)
	if hp == 0:
		damageDelay = 6
	else:
		damageDelay = 3

signal on_destroyed(Node2D)
func destroy():
	emit_signal("on_destroyed", self)
