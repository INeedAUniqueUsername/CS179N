extends Sprite
var bossName = "Lost Vector"
var vel = Vector2(0, 0)
func get_segments():
	return [
		$UpperPlate, $UpperPlate/Gun1030, $UpperPlate/Gun0000, $UpperPlate/Gun0130,
		$LowerPlate, $LowerPlate/Gun0430, $LowerPlate/Gun0600, $LowerPlate/Gun0730,
		$LeftArm, $LeftArm/Blade,
		$RightArm, $RightArm/Blade,
		self
	]
onready var ignore = get_segments()
func _physics_process(delta):
	global_translate(vel * delta)
	vel -= vel.normalized() * min(vel.length(), 120 * delta)
var hp_max = 900
var hp = hp_max
func damage(projectile):
	hp = max(0, hp - projectile.damage)
	if hp == 0:
		for s in get_segments():
			if s:
				s.destroy()
signal on_destroyed(Node2D)
func destroy():
	emit_signal("on_destroyed", self)
	queue_free()
