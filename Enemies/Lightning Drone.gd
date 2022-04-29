extends Node2D

var bossName = "Thunder Drone"
var vel = Vector2(0, 0)

var time_scale = 1.0
func set_time_scale(t:float):
	time_scale = t
	$Anim.playback_speed = t

func _ready():
	$Anim.play("wait")
	$Anim.connect("animation_finished", self, "_on_animation_finished")
	call_deferred("register_player")
	
	
signal on_destroyed
var player
func register_player():
	player = get_parent().player
	
func _physics_process(delta):
	delta *= time_scale
	if player:
		
		var speed = 180 * delta
		var offset = (player.global_position - global_position)
		vel -= vel.normalized() * speed / 2
		
		if offset.length_squared() > 180 * 180:
			vel += offset.rotated(PI/4).normalized() * speed
		else:
			vel += offset.rotated(PI/2).normalized() * speed
		
	global_translate(vel * delta)
func _on_animation_finished(name):
	if name == "wait":
		$Anim.play("wait2")
		fire_salvo_1()
	if name == "wait2":
		$Anim.play("wait")
		fire_salvo_1()
var beam = preload("res://LightningBeam.tscn")
func fire_salvo_1():
	var ignore = [self]
	for angle in [0, PI/2, PI, PI * 1.5]:
		var l = beam.instance()
		
		l.vel = vel + polar2cartesian(480, angle)
		
		ignore.append(l)
		l.ignore = ignore
		
		get_parent().add_child(l)
		l.set_global_transform(get_global_transform())
		l.rotation += angle
func fire_salvo_2():
	var ignore = [self]
	for angle in [0, PI/2, PI, PI * 1.5]:
		angle += PI/4
		
		var l = beam.instance()
		l.vel = vel + polar2cartesian(480, angle)
		
		ignore.append(l)
		l.ignore = ignore
		
		get_parent().add_child(l)
		l.set_global_transform(get_global_transform())
		l.rotation += angle


func _on_Detect_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		player = actor
var damage = 30
var drain = 60

var hp_max = 500
onready var hp = hp_max
func damage(projectile):
	hp -= projectile.damage
	if hp < 1:
		emit_signal("on_destroyed", self)
		queue_free()
