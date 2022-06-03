extends Sprite

export(float) var damage = 25.0
var vel = Vector2(0, 0)
var ignore = []

func _ready():
	$Area2D/CollisionShape2D.shape.radius = 1
	$Anim.play("Explode")
func _physics_process(delta):
	global_translate(vel * delta)
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

func expand():
	$Area2D/CollisionShape2D.shape.radius += 1
signal on_destroyed(Node2D)
func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("on_destroyed", self)
	queue_free()
