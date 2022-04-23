extends Node
var beam = load("res://LightningBeam.tscn")
var splits = 4
var time
func _ready():
	time = get_parent().lifespan / 3.0
func _physics_process(delta):
	time -= delta
	if time < 0:
		split()
func split():
	splits -= 1
	var n = get_parent()
	if splits > 0:
		var ignore = n.ignore
		
		var amp = (PI/2) * (splits / 3.0)
		n.vel = n.vel.rotated(rand_range(-amp, amp))
		
		var c = rand_range(1, 3)
		var d = n.damage / (c + 1)
		n.damage = d
		for i in range(c):
			var l = beam.instance()
			ignore.append(l)
			l.ignore = ignore
			l.damage = d
			
			n.get_parent().add_child(l)
			l.set_global_transform(n.get_global_transform())
			
			#l.vel = n.vel.rotated(rand_range(-amp, amp))
			l.vel = n.vel.rotated(rand_range(-amp, amp))
			
			l.lifespan = n.lifespan * 2 / 3.0
			l.get_node("Split").time = l.lifespan / 3.0
			l.get_node("Split").splits = splits
			
			
