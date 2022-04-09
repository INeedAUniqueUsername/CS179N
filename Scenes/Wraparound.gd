extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var limit = 300

var time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if time > 1:
		time = 0
		#to do: iterate through all children and implement wraparound
