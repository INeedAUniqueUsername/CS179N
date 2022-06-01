extends Sprite
const score = 800
func _ready():
	call_deferred("register_player")
	vel = polar2cartesian(180, rotation)
var hourglass
var player
func register_player():
	var p = get_parent()
	while p and !p.is_in_group("World"):
		p = p.get_parent()
	if !p:
		return
	player = p.player
	hourglass = p.get_node("Hourglass")
var fireCooldown = 0
const laser = preload("res://LaserBeamLarge.tscn")
const missile = preload("res://Missile.tscn")
var trailTime = 0
var turnRate = PI
var trailInterval = 0.1

var heldHourglass = null
func _physics_process(delta):
	var target_vel = polar2cartesian(180, rotation)
	var dv = target_vel - vel
	if dv.length_squared() > 0:
		vel += dv / 90.0
	
	global_translate(vel * delta)
	fireCooldown -= delta
	trailTime -= delta
	if trailTime < 0:
		trailTime = trailInterval
		Helper.create_sprite_fade(get_parent(), self, 0.5)
	
	if heldHourglass:
		hourglass.global_position = global_position
		hourglass.vel = vel
		if player and fireCooldown < 0:
			var off = player.global_position - global_position
			if off.length_squared() < 96 * 96:
				turnTowards(delta, -off)
			else:
				turnTowards(delta, off)
			for b in $Attack.get_overlapping_areas():
				if Helper.get_actor_of_body(b) == player:
					heldHourglass = false
					hourglass.vel += off.normalized() * 240
					hourglass.turnTime = 5.0
					fireCooldown = 2.0
	else:
		if hourglass and fireCooldown < 0:
			var off = hourglass.global_position - global_position
			turnTowards(delta, off)
			if off.length_squared() < 8 * 8:
				heldHourglass = true
				fireCooldown = 1.0
func turnTowards(delta, off):
	var destAngle = atan2(off.y, off.x)
	var turnDelta = atan2(sin(destAngle - rotation), cos(destAngle - rotation))
	turnDelta = sign(turnDelta) * min(abs(turnDelta), turnRate * delta)
	turn(turnDelta)
func turn(angle):
	vel = vel.rotated(angle)
	rotate(angle)
	
var vel
signal on_destroyed
onready var hp_max = [450, 900, 1350][PlayerVariables.difficulty]
onready var hp = hp_max
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
	if !actor:
		return
	if actor.is_in_group("Player"):
		player = actor
	elif actor.is_in_group("Hourglass"):
		hourglass = actor
