extends Node2D
const score = 800
onready var ignore = [self, $LowerShell, $UpperShell]
var bossName = "Space Cube"
func _ready():
	call_deferred("register_player")
	$LowerShell.destroy()
	$UpperShell.destroy()
var player
func register_player():
	player = get_parent().player
var open = false
var armorDestroyed = false
var energy = 100
var fireCooldown = 0
const laser = preload("res://LaserBeamLarge.tscn")
const missile = preload("res://Missile.tscn")
var trailTime = 0
func _physics_process(delta):
	global_translate(vel * delta)
	#vel -= vel.normalized() * min(vel.length(), 120 * delta)
	turnTime -= delta
	if turnTime < 0:
		turn()
		
	var extra_vel = vel - dir_vel
	extra_vel -= extra_vel / 90.0
	vel = extra_vel + dir_vel
	trailTime -= delta
	if trailTime < 0:
		trailTime = 0.1
		for b in [$Body, $UpperShell, $LowerShell]:
			if b:
				Helper.create_sprite_fade(get_parent(), b, 0.5)
		
	fireCooldown -= delta
	if player:
		if $Anim.current_animation == "Idle":
			$Body.frame = int(1 + (13 - 1) * (energy / 100.0))
			if energy == 0:
				if open:
					$Anim.play("Close")
				else:
					$Anim.play("Charge")
			elif fireCooldown < 0:
				energy += delta * 50
				var offset = player.global_position - $Body.global_position
				
				if armorDestroyed:
					
					fireCooldown = 1 / 4.0
					
					var l = missile.instance()
					l.target = player
					get_parent().add_child(l)
					l.set_global_transform($Body.get_global_transform())
					l.ignore = ignore
					ignore.append(l)
					var angle = randf() * PI * 2
					l.rotation = angle
					l.vel = vel + polar2cartesian(240, angle)
					energy = max(0, energy - 10)
				elif offset.length() < 420:
					fireCooldown = 1 / 9.0
					if open:
						fire_mine()
					else:
						$Anim.play("Open")
				else:
					
					if !open:
						
					
						fireCooldown = 1 / 12.0
						
						var l = laser.instance()
						get_parent().add_child(l)
						l.set_global_transform($Body.get_global_transform())
						l.ignore = [self, $LowerShell, $UpperShell]
						l.rotation = atan2(offset.y, offset.x)
						l.vel = offset.normalized() * 1080
						energy = max(0, energy - 4)
					else:
						$Anim.play("Close")
const mine = preload("res://SpaceCubeMine.tscn")	
func fire_mine():
	var l = mine.instance()
	get_parent().add_child(l)
	l.set_global_transform($Body.get_global_transform())
	l.ignore = ignore
	l.vel = vel + polar2cartesian(360, rand_range(0, PI*2))
	energy = max(0, energy - 6)
var dir_vel : Vector2 = polar2cartesian(120, PI/2 * (randi()%4))
var vel : Vector2 = dir_vel
var turnTime : float
func turn():
	turnTime = 2
	vel -= dir_vel
	dir_vel = dir_vel.rotated([-PI/2, PI/2][randi()%2])
	vel += dir_vel
signal on_destroyed
var hp = 900
var hp_max = 900
func damage(projectile):
	hp = max(0, hp - projectile.damage)
	if hp > 0:
		return
	for s in [$UpperShell, $LowerShell, self]:
		if s:
			s.destroy()
func destroy():
	emit_signal("on_destroyed", self)
	queue_free()

func _on_area_entered(area):
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		player = actor


func _on_animation_finished(anim_name):
	match anim_name:
		"Charge":
			energy = 100
			$Anim.play("Idle")
		"Fire":
			if energy == 0:
				if open:
					$Anim.play("Close")
				else:
					$Anim.play("Charge")
			else:
				$Anim.play("Idle")
		"Close":
			open = false
			if energy == 0:
				$Anim.play("Charge")
			else:
				$Anim.play("Idle")
		"Open":
			open = true
			$Anim.play("Idle")
			if energy == 0:
				$Anim.play("Close")

onready var armor = [$LowerShell, $UpperShell]
func _on_armor_destroyed(a):
	armor.erase(a)
	if armor.empty():
		armorDestroyed = true
