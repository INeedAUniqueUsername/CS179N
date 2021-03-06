extends Enemies

const score = 100

var vel = Vector2(0, 0)
func set_time_scale(t:float):
	self.time_scale = t
	$Anim.playback_speed = t
func _physics_process(delta):
	delta *= self.time_scale
	if target:
		print('target: ' + target.name)
		var speed = 180 * delta
		var offset = target.global_position - global_position
		match $Anim.current_animation:
			"Wait":
				vel -= vel.normalized() * speed / 2
				if offset.length_squared() > 180 * 180:
					vel += offset.rotated(PI/4).normalized() * speed
				else:
					vel += offset.rotated(PI/2).normalized() * speed
			"Charge":
				var rejection = vel * (1 - vel.normalized().dot(offset.normalized()))
				vel -= rejection.normalized() * min(rejection.length(), speed)
				vel += offset.normalized() * speed
	global_translate(vel * delta)
func _ready():
	if PlayerVariables.difficulty == 0:
		hp = 25
	elif PlayerVariables.difficulty == 1:
		hp = 50
	elif PlayerVariables.difficulty == 2:
		hp = 75
	$Anim.connect("animation_finished", self, "_on_animation_finished")
var salvo = 0
func _on_animation_finished(name):
	match name:
		"Wait":
			if target:
				$Anim.play("Charge")
			else:
				$Anim.play("Wait")
		"Charge":
			$Anim.play("Wait")
			if target:
				salvo += 1
				if salvo % 2 == 0:
					fire_salvo_1()
				else:
					fire_salvo_2()
const failureChance = 0.25
var beam = preload("res://LightningBeam.tscn")
func fire_salvo_1():
	var ignore = [self]
	
	for angle in [0, PI/2, PI, PI * 1.5]:
		if randf() < failureChance:
			continue
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
		if randf() < failureChance:
			continue
		angle += PI/4
		
		var l = beam.instance()
		l.vel = vel + polar2cartesian(480, angle)
		
		ignore.append(l)
		l.ignore = ignore
		
		get_parent().add_child(l)
		l.set_global_transform(get_global_transform())
		l.rotation += angle
		$Burst.play()
		


