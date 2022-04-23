extends Node2D
var vel = Vector2(0, 0)
func _ready():
	$Anim.connect("animation_finished", self, "_on_animation_finished")
	call_deferred("register_player")
var player
func register_player():
	player = get_parent().player
	
func _physics_process(delta):
	if player:
		
		var speed = 1/15.0
		var offset = (player.global_position - global_position)
		if $Anim.current_animation == "Waiting":
			if offset.length_squared() > 360 * 360:
				var rejection = vel * (1 - vel.normalized().dot(offset.normalized()))
				vel -= rejection.normalized() * min(rejection.length(), speed)
				vel += offset.normalized() * speed
			else:
				$Anim.play("Charging")
		if $Anim.current_animation == "Charging":
			vel -= vel.normalized() * speed / 2
			
			if offset.length_squared() > 240 * 240:
				vel += offset.rotated(PI/4).normalized() * speed
			else:
				vel += offset.rotated(PI/2).normalized() * speed
		elif $Anim.current_animation == "Ready":
			var rejection = vel * (1 - vel.normalized().dot(offset.normalized()))
			vel -= rejection.normalized() * min(rejection.length(), speed)
			vel += offset.normalized() * speed
		elif $Anim.current_animation == "Recovering":
			vel -= vel / 60
		
	global_translate(vel)
func _on_animation_finished(name):
	if name == "Charging":
		$Anim.play("Ready")
	elif name == "Ready":
		vel += (player.global_position - global_position).normalized() * 5
		$Anim.play("Flashing")
	elif name == "Flashing":
		$Anim.play("Recovering")
	elif name == "Recovering":
		$Anim.play("Waiting")
func _on_Detect_area_entered(area):
	var actor = Helper.get_parent_actor(area)
	if actor and actor.is_in_group("Player"):
		player = actor
