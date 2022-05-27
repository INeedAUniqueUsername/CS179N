extends Node2D
const score = 50
var moveSpeed = 70
var rotationSpeed = 0.5
var vel = Vector2(0, 0)

var hp = 100 setget, get_hp
func get_hp(): return hp

var damage = 10
var rng = RandomNumberGenerator.new()

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
	rng.randomize()
	var x = rng.randf_range(-1, 1)
	var y = rng.randf_range(-1, 1)
	vel = Vector2(x, y)
	
func _physics_process(delta):
	global_translate(vel.normalized() * moveSpeed * delta)
	rotation += delta * rotationSpeed

signal on_destroyed
func damage(projectile):
	hp -= projectile.damage
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
		rng.randomize()
		var x = rng.randf_range(-50, 50)
		laserdrone_load.global_position = global_position + Vector2(x, x)
		laserdrone_load.rotation_degrees = rng.randf_range(0, 360)

func spawn_broken():
	for i in range(3):
		var broken_load = self.duplicate()
		rng.randomize()
		var x = rng.randf_range(-1, 1)
		var y = rng.randf_range(-1, 1)
		broken_load.vel = Vector2(x, y)
		broken_load.is_broken = true
		
		get_parent().add_child(broken_load)
		broken_load.scale = Vector2(0.75, 0.75)
		broken_load.global_position = global_position

func _on_Damage_Area_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		var velDiff = self.vel - actor.common.vel
		actor.common.vel += velDiff / 2
		self.vel -= velDiff
		actor.damage(self)
