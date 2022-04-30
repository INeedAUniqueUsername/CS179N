extends Node2D


func _ready():
	call_deferred("register_player")
var player
func register_player():
	player = get_parent().player


var fireCooldown = 0
const laser = preload("res://LaserBeam.tscn")
func _physics_process(delta):
	global_translate(vel * delta)
	#vel -= vel.normalized() * min(vel.length(), 120 * delta)
	turnTime -= delta
	if turnTime < 0:
		turn()
	fireCooldown -= delta
	if player:
		var offset = player.global_position - $Crosshair.global_position
		var dist = offset.length() / 15.0
		dist = max(dist, min(3, offset.length()))
		
		$Crosshair.global_position += offset.normalized() * dist
		if offset.length() < 30 and fireCooldown < 0:
			fireCooldown = 1 / 8.0
			var l = laser.instance()
			
			
			get_parent().add_child(l)
			l.set_global_transform($Body.get_global_transform())
			l.ignore = [self, $LowerShell, $UpperShell]
			offset = player.global_position - $Body.global_position
			l.rotation = atan2(offset.y, offset.x)
			l.vel = offset.normalized() * 640
			
var vel : Vector2 = polar2cartesian(200, rand_range(-PI/2, PI/2))
var turnTime : float
func turn():
	turnTime = 5
	vel = vel.rotated(rand_range(-PI/2, PI/2))
signal on_destroyed
var hp = 600
func damage(projectile):
	hp = max(0, hp - projectile.damage)
	if hp < 1:
		emit_signal("on_destroyed", self)
		queue_free()
	pass


func _on_area_entered(area):
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		player = actor
