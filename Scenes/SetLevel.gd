extends Node

export(bool) var active = true
export(int) var level = 1
export(bool) var bossOnly = true
# Called when the node enters the scene tree for the first time.
func _ready():
	if active:
		PlayerVariables.level = level
