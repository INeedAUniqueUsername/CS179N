extends Particles2D
func _ready():
	if Helper.lightningCount == 5:
		queue_free()
		return
	Helper.lightningCount += 1
	connect("tree_exiting", self, "on_exit")
func on_exit():
	Helper.lightningCount -= 1
