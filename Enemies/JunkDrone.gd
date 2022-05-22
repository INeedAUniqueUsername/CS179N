extends Node2D
const score = 50
var moveSpeed = 70
var vel = Vector2(0, 0)

var hp = 100 setget, get_hp
func get_hp(): return hp

var rng = RandomNumberGenerator.new()

func _ready():
	# Start out at a random direction
	rng.randomize()
	var x = rng.randf_range(-1, 1)
	var y = rng.randf_range(-1, 1)
	vel = Vector2(x, y)
	
func _physics_process(delta):
	global_translate(vel.normalized() * moveSpeed * delta)

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
		
		queue_free()

func _on_Damage_Area_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
#		vel = global_position.direction_to(actor)
		pass
