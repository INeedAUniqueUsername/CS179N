extends Node2D
const score = 50
var rotationSpeed = 0.5
var vel = Vector2(0, 0)

var hp = 100 setget, get_hp
func get_hp(): return hp

var damage = 10

var is_broken = false

const laserdrone = preload("res://Enemies/LaserDrone.tscn")

func _ready():
	if PlayerVariables.difficulty == 0:
		hp = 50
	elif PlayerVariables.difficulty == 1:
		hp = 100
	elif PlayerVariables.difficulty == 2:
		hp = 150
	# Start out at a random direction
	vel = polar2cartesian(70, randf() * PI*2)
	
func _physics_process(delta):
	global_translate(vel * delta)
	rotation += delta * rotationSpeed

signal on_destroyed
func damage(projectile):
	var dmg = projectile.damage
	if projectile.is_in_group("Laser") or projectile.is_in_group("Lightning"):
		dmg *= 0.4
	hp -= dmg
	if hp < 1:
		emit_signal("on_destroyed", self)
		var enemydie = AudioStreamPlayer.new()
		get_parent().add_child(enemydie)
		var dieaudio = preload("res://Sound/enemydie_explosionCrunch_000.ogg")
		enemydie.stream = dieaudio
		enemydie.play()
		remove_child(enemydie)
		
		if !is_broken:
			spawn_laserdrone()
			spawn_broken()
			
		queue_free()

func spawn_laserdrone():
	for i in range(2):
		var laserdrone_load = laserdrone.instance()
		
		get_parent().add_child(laserdrone_load)
		laserdrone_load.global_position = global_position
		laserdrone_load.rotation_degrees = rand_range(0, 360)
		laserdrone_load.vel = polar2cartesian(120, randf() * PI * 2)
func spawn_broken():
	for i in range(3):
		var broken_load = self.duplicate()
		broken_load.vel = polar2cartesian(1, randf() * PI * 2)
		broken_load.is_broken = true
		
		get_parent().add_child(broken_load)
		broken_load.scale = Vector2(0.5, 0.5)
		broken_load.global_position = global_position

func _on_Damage_Area_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if !actor:
		return
	if actor.is_in_group("Player"):
		var velDiff = self.vel - actor.common.vel
		actor.common.vel += velDiff
		self.vel -= velDiff / 5.0
		actor.damage(self)
	elif actor.is_in_group("Actor") and !actor.is_in_group("Projectile"):
		var velDiff = self.vel - actor.vel
		actor.vel += velDiff
		self.vel -= velDiff / 5.0
		actor.damage(self)
