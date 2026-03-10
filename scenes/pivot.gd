extends Node2D
var rotation_speed = PI
func _process(delta):
	rotation += rotation_speed * delta/30
