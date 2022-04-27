extends Button

export(NodePath) var ap
export(NodePath) var spr
export(Array, String) var anims : Array
var index = 0
func _ready():
	ap=get_node(ap)
	spr = get_node(spr)
	#anims = Array(ap.get_animation_list())
func _on_Button_pressed():
	var a : AnimationPlayer = ap
	var c = a.current_animation
	index += 1
	var anim = anims[index % len(anims)]
	a.get_animation(anim).set_loop(true)
	a.play(anim)
