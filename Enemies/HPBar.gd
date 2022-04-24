extends Sprite

onready var width = region_rect.size.x
func _ready():
	get_parent().connect("on_damaged", self, "on_damaged")
func on_damaged(parent, projectile):
	if modulate.a == 0:
		$Anim.play("Show")
	elif $Anim.current_animation == "Visible":
		$Anim.seek(0)
	else:
		$Anim.play("Visible")
func _process(delta):
	var p = get_parent()
	$Front.region_rect.size.x = int(width * p.hp / p.hp_max)
func _on_animation_finished(n):
	if n == "Show":
		$Anim.play("Visible")
	elif n == "Visible":
		$Anim.play("Fade")
