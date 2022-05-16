extends Sprite
export(int) var hp_max = 60
onready var hp = hp_max

var damageDelay = 0
var vel : Vector2 setget set_vel, get_vel
export(NodePath) var main = "../.."
export(NodePath) var parent = ".."
func get_vel():
	if 'vel' in parent:
		return parent.vel
	if 'vel' in main:
		return main.vel
	return Vector2(0, 0)
	# quick fix
	
func set_vel(vel):
	return
	parent.vel = vel
func _ready():
	main = get_node(main)
	parent = get_node(parent)
	$Area.connect("area_entered", self, "on_area_entered")
	$Area.connect("area_exited", self, "on_area_exited")
var hit = []
func on_area_entered(area):
	if hp == 0:
		return
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	
	if main.ignore.has(actor):
		return
	hit.append(actor)
	main.ignore.append(actor)
	
	if actor and actor.is_in_group("Player"):
		var velDiff = vel - actor.common.vel
		actor.common.vel = -actor.common.vel
		#parent.vel -= velDiff
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
	#Laser beats shields
	if hp == 0:
		#pretend as if the projectile did not hit us
		if 'pierce' in projectile:
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
	queue_free()
