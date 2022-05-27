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
			spawn_broken()
		
		queue_free()

func spawn_broken():
	self.scale = Vector2(0.75, 0.75)
	for i in 3:
		var broken_load = self.duplicate()
		rng.randomize()
		var x = rng.randf_range(-1, 1)
		var y = rng.randf_range(-1, 1)
		broken_load.vel = Vector2(x, y)
		broken_load.is_broken = true
		
		get_parent().add_child(broken_load)
		broken_load.set_global_transform(get_global_transform())

func _on_Damage_Area_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		var velDiff = self.vel - actor.common.vel
		actor.common.vel += velDiff / 2
		self.vel -= velDiff
		actor.damage(self)
