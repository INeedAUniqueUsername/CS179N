extends Node2D

var player : Node2D
var vel = Vector2(0, 0)
var ignore = []
var slashCooldown = slashInterval
const slashInterval = 3

var ready = false
var slashing = false

var time = randi()
func _physics_process(delta):
	global_translate(vel * delta)
func _process(delta):
	time += delta
	if slashing or !ready:
		Helper.create_sprite_fade(get_parent().get_parent(), $Body, 0.2)
	if player and ready:
		var speed = 180
		var offset = player.global_position - global_position
		
		slashCooldown = max(0, slashCooldown - delta)
		if offset.length() > 320:
			var rejection = vel * (1 - vel.normalized().dot(offset.normalized()))
			vel -= rejection.normalized() * min(rejection.length(), speed * delta)
			if vel.length() < 240:
				vel += offset.normalized() * min(speed * delta, offset.length())
		elif slashing:
			vel += offset.normalized() * speed * delta
		else:
			vel += offset.normalized().rotated(PI/2) * speed * delta / 4.0
			if slashCooldown == 0:
				slashCooldown = slashInterval
				slashing = true
				if randf() < 0.5:
					$Slash.play("Slash")
				else:
					$Slash.play("Spin")
			
		
		var dest_angle = (player.global_position - global_position)
		dest_angle = atan2(dest_angle.y, dest_angle.x) + PI/4 + sin(time * PI * 2 / 2.0) * PI / 6
		var diff = dest_angle - rotation
		diff = atan2(sin(diff), cos(diff))
		var turnRate = PI * 2 / 3
		rotation += sign(diff) * min(abs(diff), turnRate * delta)
	
var hp = 600
var hp_max = 600
func damage(projectile):
	hp = max(0, hp - projectile.damage)
	if hp == 0:
		destroy()
signal on_destroyed(Node2D)
func destroy():
	emit_signal("on_destroyed", self)
	queue_free()
var damage = 20
func _on_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if ignore.has(actor):
		return
	if actor and actor.is_in_group("Actor"):
		if slashing:
			damage = 20
			actor.damage(self)


func _on_animation_finished(anim_name):
	if anim_name == "Deploy":
		ready = true
	else:
		slashing = false
