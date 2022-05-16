extends Sprite
var hp : int = 600
var hp_max : int = 600
var vel : Vector2 = Vector2(0, 0)
var player : Node2D


onready var ignore = [self, $LeftCannon, $RightCannon, $"../LeftHand", $"../RightHand"]
func _ready():
	call_deferred("register_player")
func register_player():
	var p = get_parent().get_parent()
	player = p.player
	if !player:
		p.connect("registered_player", self, "on_registered_player")
func on_registered_player(p):
	player = p
signal on_destroyed(Node2D)
func destroy():
	for c in [$LeftCannon, $RightCannon]:
		if c:
			c.deploy_sword()
	emit_signal("on_destroyed", self)
	queue_free()
func damage(projectile):
	hp = max(0, hp - projectile.damage)
	if hp == 0:
		destroy()
	pass
var fireCooldown = 0
const fireInterval = 1.5
const projectile = preload("res://Sprites/StarBeam.tscn")

func _process(delta):
	fireCooldown = max(0, fireCooldown - delta)
	if player:
		var offset = (player.global_position - global_position)
		var dest_angle = offset
		dest_angle = atan2(dest_angle.y, dest_angle.x)
		var diff = dest_angle - rotation
		diff = atan2(sin(diff), cos(diff))
		
		var turnRate = PI * 2 / 3
		rotation += sign(diff) * min(abs(diff), turnRate * delta)
		
		var speed = 180
		
		if offset.length() > 240:
			var rejection = vel * (1 - vel.normalized().dot(offset.normalized()))
			vel -= rejection.normalized() * min(rejection.length(), speed * delta)
			if vel.length() < 180:
				vel += offset.normalized() * min(speed * delta, offset.length())
				
	if attackable > 0:
		if fireCooldown == 0:
			fireCooldown = fireInterval
			var b = projectile.instance() as Node2D
			b.ignore = ignore
			ignore.append(b)
			get_parent().get_parent().add_child(b)
			b.global_position = $BeamOrigin.global_position
			b.vel = vel + polar2cartesian(480, rotation)
func _physics_process(delta):
	global_translate(vel * delta)

var attackable = 0
func _on_BeamRange_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor == player:
		attackable += 1
func _on_BeamRange_exited(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor == player:
		attackable -= 1
