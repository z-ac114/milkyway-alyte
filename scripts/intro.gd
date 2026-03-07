extends Node2D
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var logo: Sprite2D = $CanvasLayer/Logo
@onready var label: Label = $CanvasLayer/Label

func _ready() -> void:
	Global.play_bgm = true
	await get_tree().create_timer(0.5).timeout
	Global.emit_signal("bgm_intro")
	animation_player.play("intro")


func _process(delta: float) -> void:
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://scenes/test.tscn")
