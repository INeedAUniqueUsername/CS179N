extends Node2D
const score = 100
var enemyName = "Shield Drone"
var vel = Vector2(0, 0)
var vel1 = Vector2(0, 0)

var ignore = [self]

var rng = RandomNumberGenerator.new()
const health_pickup = preload("res://Powerups/HealthPickup.tscn")
const fuel_pickup = preload("res://Powerups/FuelPickup.tscn")
const energy_pickup = preload("res://Powerups/EnergyPickup.tscn")

signal on_destroyed
signal on_damaged
var player
var time_scale = 1.0
func set_time_scale(t:float):
	time_scale = t
	$Anim.playback_speed = t


func _physics_process(delta):
	if player != null:
		look_at(player.global_position)
		rotate(PI/2)
	delta *= time_scale
	
	if player:		
		var speed = 180 * delta
		var offset = (player.global_position - global_position)
		vel -= vel.normalized() * speed 
		if offset.length_squared() > 180 * 180:
			vel += offset.rotated(PI/4).normalized() * speed
		else:
			vel += offset.rotated(PI/2).normalized() * speed
		vel += offset.normalized() * speed 
	global_translate(vel * delta)


func register_player():
	player = get_parent().player
	

func _on_Detect_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		player = actor

var hp_max = 300
onready var hp = hp_max

func damage(projectile):
	if hp == 0:
		return
	emit_signal("on_damaged", self, projectile)
	hp = max(hp - projectile.damage, 0)
	if hp == 0:
		emit_signal("on_destroyed", self)
		for s in $Shield.get_children():
			s.destroy()
		$Anim.play("Destroyed")
		
		rng.randomize()
		var rand = rng.randf_range(0, 100)
		
		if rand < 25:
			var d = health_pickup.instance()
			get_parent().add_child(d)
			d.global_position = global_position
		elif rand < 50:
			var d = fuel_pickup.instance()
			get_parent().add_child(d)
			d.global_position = global_position
		elif rand < 75:
			var d = energy_pickup.instance()
			get_parent().add_child(d)
			d.global_position = global_position
