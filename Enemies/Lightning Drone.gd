extends Enemies

const score = 30
var vel = Vector2(0, 0)


var time_scale = 1.0
func set_time_scale(t:float):
	time_scale = t
	$Anim.playback_speed = t


var patrol_time = 10
var curr_patrol_time = 0
func _physics_process(delta):
	delta *= time_scale
	if target:
		var speed = 180 * delta
		var offset = (target.global_position - global_position)
		vel -= vel.normalized() * speed / 2
		
		if offset.length_squared() > 180 * 180:
			vel += offset.rotated(PI/4).normalized() * speed
		else:
			vel += offset.rotated(PI/2).normalized() * speed
		
	elif target == null:
		curr_patrol_time -= delta
		if curr_patrol_time < 0:
			curr_patrol_time = patrol_time
			rotate(PI/2)
		
	global_translate(vel * delta)

func _ready():
	hp = 50
	$Anim.play("wait")
	$Anim.connect("animation_finished", self, "_on_animation_finished")


func _on_animation_finished(name):
	if name == "wait":
		$Anim.play("wait2")
		if atk_target != null:
			fire_salvo_1()
	if name == "wait2":
		$Anim.play("wait")
		if atk_target != null:
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
		


