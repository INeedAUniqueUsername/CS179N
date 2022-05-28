extends Sprite
var bossName = "Rawbawjaw"
var vel = Vector2(0, 0)
var mass = 10.0
func get_segments():
	return [
		$Plates/UpperPlate, $Plates/UpperPlate/Gun1030, $Plates/UpperPlate/Gun0000, $Plates/UpperPlate/Gun0130,
		$Plates/LowerPlate, $Plates/LowerPlate/Gun0430, $Plates/LowerPlate/Gun0600, $Plates/LowerPlate/Gun0730,
		$Arms/LeftArm, $Arms/LeftArm/Blade,
		$Arms/RightArm, $Arms/RightArm/Blade,
		self
	]
onready var ignore = get_segments()
var player : Node2D

var weapons
func _ready():
	var p = get_parent()
	player = p.player
	if !player:
		p.connect("registered_player", self, "on_registered_player")
	
	weapons = [
		$Plates/LowerPlate/Gun0430, $Plates/LowerPlate/Gun0600, $Plates/LowerPlate/Gun0730,
		$Plates/UpperPlate/Gun0000, $Plates/UpperPlate/Gun0130, $Plates/UpperPlate/Gun1030,
		$Arms/LeftArm/Blade, $Arms/RightArm/Blade]
	for w in weapons:
		w.connect("on_destroyed", self, "on_weapon_destroyed")
func on_weapon_destroyed(w):
	weapons.erase(w)
	if weapons.empty():
		activate_self_destruct()
func activate_self_destruct():
	destTurnRate = 0
	$Anim.play("SelfDestruct")
func on_registered_player(pl):
	player = pl
	
var turnRate = PI/2
var destTurnRate = PI/2
func _physics_process(delta):
	global_translate(vel * delta)
	vel -= vel.normalized() * min(vel.length(), 120 * delta)
	turnRate += sign(destTurnRate - turnRate) * min(abs(destTurnRate - turnRate), delta * PI / 2)
	rotation += delta * turnRate
	if !player:
		return
	var an = $Arms/Anim.current_animation
	if an == "SpinCCW" or an == "SpinCW" or $Anim.current_animation == "SelfDestruct":
		vel += (player.global_position - global_position).normalized() * 360 * delta
var spinInterval = 4
var spinCooldown = spinInterval

var reverseInterval = 16
var reverseCooldown = reverseInterval

var missileInterval = 8
var missileCooldown = missileInterval
const missile = preload("res://Missile.tscn")

#var selfDestructTime = 120
func _process(delta):
	if $Anim.current_animation == "SelfDestruct":
		return
	#selfDestructTime -= delta
	#if selfDestructTime < 0:
	#	$Anim.play("SelfDestruct")
	
	spinCooldown -= delta
	if spinCooldown < 0:
		spinCooldown = spinInterval
		if turnRate < 0:
			$Arms/Anim.play("SpinCCW")
		else:
			$Arms/Anim.play("SpinCW")
	reverseCooldown -= delta
	if reverseCooldown < 0:
		reverseCooldown = reverseInterval
		destTurnRate *= -1
	
	if !player:
		return
	missileCooldown -= delta
	if missileCooldown < 0:
		
		missileCooldown = missileInterval
		var offset = player.global_position - global_position
		var m = Helper.create_projectile(
			missile,
			get_parent(),
			ignore,
			global_position,
			vel + offset.normalized() * 240,
			atan2(offset.y, offset.x))
		m.target = player
		m.lifespan = 5
		m.lifetime = 5
onready var hp_max = [450, 900, 1350][PlayerVariables.difficulty]
onready var hp = hp_max
func damage(projectile):
	hp = max(0, hp - projectile.damage)
	if hp == 0:
		destroy()
	elif hp < hp_max / 9.0:
		activate_self_destruct()
signal on_destroyed(Node2D)
func destroy():
	emit_signal("on_destroyed", self)
	queue_free()
func _on_spin_finished(anim_name):
	var pos = {}
	var rot = {}
	for c in [$Arms/LeftArm, $Arms/RightArm]:
		if c:
			pos[c] = c.global_position
			rot[c] = c.global_rotation
	$Arms.rotation = 0
	for c in [$Arms/LeftArm, $Arms/RightArm]:
		if c:
			c.global_position = pos[c]
			c.global_rotation = rot[c]
var explosion = preload("res://MissileExplosion.tscn") 
func explode():
	var e = Helper.create_projectile(
		explosion,
		get_parent(),
		[],
		global_position,
		vel,
		0)
	e.scale *= 10
	e.damage *= 10
func _on_self_destruct_finished(an):
	explode()
	
	#wait some time 
	var t = Timer.new()
	t.wait_time = 8
	get_parent().add_child(t)
	get_parent().remove_child(self)
	t.start()
	yield(t, "timeout")
	destroy()
