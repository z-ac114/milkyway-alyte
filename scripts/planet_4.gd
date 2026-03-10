extends Sprite2D

@onready var pivot: Sprite2D = $"../pivot"

var radius = 260.0
var speed = 0.9
var angle = 0.0
var center: Node2D
var rotation_speed = PI

func _ready():
	center = pivot

func _process(delta):
	angle += speed * delta
	position = center.position + Vector2(cos(angle), sin(angle)) * radius
	rotation += rotation_speed * delta/50
