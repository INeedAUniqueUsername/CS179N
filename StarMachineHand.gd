extends Sprite
export(NodePath) var head
var connected = true
var pos_offset: Vector2
var player : Node2D
func _ready():
	head = get_node(head) as Node2D
	head.connect("on_destroyed", self, "on_head_destroyed")
	pos_offset = global_position - head.global_position
	pos_offset = pos_offset.rotated(-head.rotation)
	call_deferred("register_player")
func on_head_destroyed(h):
	head = null
func register_player():
	var p = get_parent().get_parent()
	player = p.player
	if !player:
		p.connect("registered_player", self, "on_registered_player")
func on_registered_player(p):
	player = p
var punchTime = 0
const punchInterval = 10
var punchCooldown = punchInterval
const projectiles = [
	preload("res://Sprites/StarFragment.tscn"),
	preload("res://PlasmaBall.tscn"),
	preload("res://SwordBeam.tscn"),
	#preload("res://Missile.tscn")
]
var shootCooldown = 0
var shootInterval = 1.0
func _process(delta):
	if !player:
		return
	punchCooldown = max(0, punchCooldown - delta)
	shootCooldown = max(0, shootCooldown - delta)
	if punchTime > 0:
		punchTime -= delta
		Helper.create_sprite_fade(get_parent().get_parent(), self, 0.1)
	else:
		if targetInRange and punchCooldown <= 0:
			$Anim.play("Punch")
			punchTime = 2
			punchCooldown = punchInterval
			vel = polar2cartesian(300, rotation)
		else:
			var offset: Vector2
			var speed = 180
			if head:
				var homePos = head.global_position + pos_offset.rotated(head.rotation)
				offset = homePos - global_position
				var rejection = vel * (1 - vel.normalized().dot(offset.normalized()))
				vel -= rejection.normalized() * min(rejection.length(), speed * delta)
				if vel.length() < 180:
					vel += offset.normalized() * min(speed * delta, offset.length())
			else:
				offset = player.global_position - global_position
				if offset.length() > 240:
					var rejection = vel * (1 - vel.normalized().dot(offset.normalized()))
					vel -= rejection.normalized() * min(rejection.length(), speed * delta)
					if vel.length() < 180:
						vel += offset.normalized() * min(speed * delta, offset.length())
			var dest_angle = (player.global_position - global_position)
			dest_angle = atan2(dest_angle.y, dest_angle.x)
			var diff = dest_angle - rotation
			diff = atan2(sin(diff), cos(diff))
			var turnRate = PI * 2 / 3
			rotation += sign(diff) * min(abs(diff), turnRate * delta)
			
			if shootCooldown <= 0 and abs(diff) < PI / 8:
				
				
				var ignore = []
				if head:
					ignore = head.ignore
				else:
					for c in get_parent().get_children():
						ignore.append(c)
				var projectile = projectiles[randi() % len(projectiles)]
				var b = projectile.instance() as Node2D
				if 'target' in b:
					b.target = player
				b.ignore = ignore
				ignore.append(b)
				get_parent().get_parent().add_child(b)
				b.global_position = $BeamOrigin.global_position
				var missileSpeed = 480 #720
				b.vel = vel + polar2cartesian(missileSpeed, rotation)
				b.global_rotation = global_rotation
				$Anim.play("Shoot")
				shootCooldown = shootInterval
const mass = 10.0
func _physics_process(delta):
	global_translate(vel * delta)
var hp_max : int = 600
onready var hp : int = hp_max
var vel : Vector2 = Vector2(0, 0)
signal on_destroyed(Node2D)
func damage(projectile):
	hp = max(0, hp - projectile.damage)
	if hp == 0:
		destroy()
func destroy():
	emit_signal("on_destroyed", self)
	queue_free()
var targetInRange = false
func _on_AttackRange_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor == player:
		targetInRange = true
func _on_AttackRange_exited(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor == player:
		targetInRange = false
var damage = 0
func _on_PunchArea_entered(area):
	if punchTime < 0:
		return
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor == player:
		var velDiff = vel - actor.common.vel
		damage = velDiff.length() / 8
		actor.damage(self)
		
		actor.common.vel += 3 * velDiff / 2
