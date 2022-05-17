extends Node2D

export(PackedScene) var projectile = preload("res://LaserBeam.tscn")
export(float) var fireInterval = 1
export(int) var missileSpeed = 480
var fireCooldown = fireInterval
onready var actor = Helper.get_root_actor(self)
func _process(delta):
	fireCooldown -= delta
	if fireCooldown < 0 and !detected.empty():
		fireCooldown = fireInterval
		
		Helper.create_projectile(
			projectile,
			actor.get_parent(),
			actor.ignore,
			global_position,
			actor.vel + polar2cartesian(missileSpeed, global_rotation),
			global_rotation
			)
var detected = []
func _on_detect_entered(area):
	var actor = Helper.get_actor_of_body(area)
	if actor and actor.is_in_group("Player"):
		detected.append(actor)
func _on_detect_exited(area):
	var actor = Helper.get_actor_of_body(area)
	if actor and actor.is_in_group("Player"):
		detected.erase(actor)
