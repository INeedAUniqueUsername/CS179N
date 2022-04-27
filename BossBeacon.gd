extends Node2D

var vel = Vector2(0, 0)
const hp_max = 100
onready var hp = hp_max
signal on_damaged
signal on_destroyed
func _on_area_entered(area):
	var actor = Helper.get_parent_actor(area)
	
func damage(projectile):
	if hp == 0:
		return
	emit_signal("on_damaged", self, projectile)
	hp = max(hp - projectile.damage, 0)
	if hp == 0:
		emit_signal("on_destroyed", self)
		$Anim.play("Destroy")
		$Area.queue_free()
func _physics_process(delta):
	global_translate(vel * delta)
	vel -= vel.normalized() * min(vel.length(), 120 * delta)
