extends AnimatedSprite

export(float) var damage = 25.0

var ignore = []

func _on_Area2D_area_entered(area):
	if !Helper.is_area_body(area):
		return
	var actor = Helper.get_parent_actor(area)
	if !actor:
		return
	if actor.is_in_group("Projectile"):
		return
	if ignore.has(actor):
		return
	actor.damage(self)
