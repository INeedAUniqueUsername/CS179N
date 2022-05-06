extends Node2D
func _ready():
	call_deferred("register_player")
var player
func register_player():
	player = get_parent().player
	
var fireCooldown = 1
func _physics_process(delta):
	global_translate(vel * delta)
	#vel -= vel.normalized() * min(vel.length(), 120 * delta)
	if player:
		fireCooldown -= delta
		if fireCooldown < 0:
			fireCooldown = 1
			
		pass
var vel : Vector2 = Vector2(0, 0)
var turnTime : float
signal on_destroyed
var hp = 900
func damage(projectile):
	hp = max(0, hp - projectile.damage)
	if hp > 0:
		return
	destroy()
func destroy():
	emit_signal("on_destroyed", self)
	queue_free()

func _on_area_entered(area):
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		player = actor

