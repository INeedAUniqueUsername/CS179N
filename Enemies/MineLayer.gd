extends Node2D
func _ready():
	call_deferred("register_player")
var player
func register_player():
	player = get_parent().player
	
var ignore = []
var fireCooldown = 1

var turnTime = 0
var turnRate = 0
func _physics_process(delta):
	turnTime = max(0, turnTime - delta)
	if turnTime > 0:
		turnTime -= delta
		rotation += turnRate * delta
	else:
		turnTime += rand_range(2, 5)
		turnRate = rand_range(-1, 1) * PI / 2
	var targetVel = polar2cartesian(120, rotation - PI/2)
	var velDiff = targetVel - vel
	var accel = 240
	vel += velDiff.normalized() * min(velDiff.length(), accel * delta)
	global_translate(vel * delta)
	#vel -= vel.normalized() * min(vel.length(), 120 * delta)
	if player:
		fireCooldown -= delta
		if fireCooldown < 0:
			fireCooldown = 1
var vel : Vector2 = Vector2(0, 0)
signal on_destroyed
var hp = 900
func damage(projectile):
	hp = max(0, hp - projectile.damage)
	if hp > 0:
		return
	destroy()
func destroy():
	for s in [$FrontShield, $LeftShield, $RightShield]:
		s.destroy()
	emit_signal("on_destroyed", self)
	queue_free()

func _on_area_entered(area):
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		player = actor

