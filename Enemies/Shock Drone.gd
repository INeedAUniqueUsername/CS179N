extends Node2D



var enemyName = "Thunder Drone"
var vel = Vector2(0, 0)

var time_scale = 1.0
func set_time_scale(t:float):
	time_scale = t
	$Anim.playback_speed = t

func _ready():
	$Anim.play("Charge")
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
		if $Anim.current_animation == "waiting":
			if offset.length_squared() > 240 * 240:
				var rejection = vel * (1 - vel.normalized().dot(offset.normalized()))
				vel -= rejection.normalized() * min(rejection.length(), speed)
				
				
				vel += offset.normalized() * min(speed, 240 - vel.length())
			else:
				$Anim.play("Charge")
		if $Anim.current_animation == "Charge":
			vel -= vel.normalized() * speed / 2
			
			if offset.length_squared() > 180 * 180:
				vel += offset.rotated(PI/4).normalized() * speed
			else:
				vel += offset.rotated(PI/2).normalized() * speed
		elif $Anim.current_animation == "Fully Charged":
			var rejection = vel * (1 - vel.normalized().dot(offset.normalized()))
			vel -= rejection.normalized() * min(rejection.length(), speed)
			vel += offset.normalized() * speed
		elif $Anim.current_animation == "No Charge":
			vel -= vel / 60
		
	global_translate(vel * delta)
func _on_animation_finished(name):
	if name == "Charge":
		$Anim.play("Ready")
	elif name == "Ready":
		flashes = 3
		start_flash()
	elif name == "Fully Charged":
		flashes -= 1
		if flashes > 0:
			start_flash()
		else:
			$Anim.play("No charge")
	elif name == "No charge":
		$Anim.play("Charge")


var flashes = 3
func start_flash():
	
	if flashes == 3:
		vel += (player.global_position - global_position).normalized() * 240
	else:
		vel = (player.global_position - global_position).normalized() * vel.length()
	$Anim.play("Fully Charged")
func _on_Detect_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		player = actor
var damage = 10
var drain = 20
func _on_Damage_area_entered(area):
	if $Anim.current_animation != "Fully Charged":
		return
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		flashes = 0
		actor.damage(self)
		vel = -vel
var hp_max = 100
onready var hp = hp_max
func damage(projectile):
	hp -= projectile.damage
	if hp < 1:
		emit_signal("on_destroyed", self)
		queue_free()

