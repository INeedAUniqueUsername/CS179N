extends Button

export(NodePath) var ap
export(Array, String) var anims : Array
export(String, MULTILINE) var desc : String
var index = -1
func _ready():
	if !PlayerVariables.bossesMet[name]:
		disabled = true
		
		var q = $Question
		for c in get_children():
			remove_child(c)
		add_child(q)
		q.show()
		return
	
	ap=get_node(ap)
	connect("mouse_entered", self, "show_border")
	connect("mouse_exited", self, "hide_border")
	
	connect("pressed", self, "pressed")
func show_border():
	$MenuClickSound.play()
	$Border.visible = true
	get_node("../Desc").text = desc
func hide_border():
	$Border.visible = false
	#get_parent().get_node("Desc").text = ""
func pressed():
	$MenuClickSound.play()
	if !ap:
		return
	var a : AnimationPlayer = ap
	var c = a.current_animation
	index += 1
	var anim = anims[index % len(anims)]
	a.get_animation(anim)
	a.play(anim)
