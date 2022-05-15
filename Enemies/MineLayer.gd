extends Node2D

func _ready():
	player = get_parent().player
	if !player:
		get_parent().connect("registered_player", self, "on_registered_player")
var player : Node2D
func on_registered_player(pl):
	player = pl

var turnTime = 0
var turnRate = 0

onready var bombCooldown = bombInterval
var bombInterval = 1
const bomb = preload("res://MineLayerBomb.tscn")

onready var mineCooldown = mineInterval
var mineInterval = 1
const mine = preload("res://Sprites/MineLayerSpike.tscn")

onready var ignore = [self, $FrontShield, $LeftShield, $RightShield]
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
		bombCooldown = max(0, bombCooldown - delta)
		mineCooldown = max(0, mineCooldown - delta)
		var offset = player.global_position - global_position
		if bombCooldown == 0:
			bombCooldown = bombInterval
			var b = bomb.instance()
			b.ignore = ignore
			ignore.append(b)
			get_parent().add_child(b)
			get_parent().register(b)
			b.rotationMatchesVel = false
			b.global_position = $LeftCannon/Origin.global_position
			b.vel = vel + polar2cartesian(120, rotation - PI/2 - PI/8)
			
		if mineCooldown == 0:
			mineCooldown = mineInterval
			var m = mine.instance()
			m.ignore = ignore
			ignore.append(m)
			get_parent().add_child(m)
			get_parent().register(m)
			m.global_position = $Body/Origin.global_position
			m.vel = vel# + polar2cartesian(120, rotation + PI/2)
var vel : Vector2 = Vector2(0, 0)
signal on_destroyed
var hp = 1200
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

