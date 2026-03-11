extends Node2D

var unlock_screen = preload("res://scenes/unlock_ui.tscn")
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var camera_2d: Camera2D = $Camera2D
@onready var mercury: TextureButton = $Mercury
@onready var venus: TextureButton = $Venus
@onready var earth: TextureButton = $Earth
@onready var mars: TextureButton = $Mars
@onready var jupiter: TextureButton = $Jupiter
@onready var label: Label = $Label
@onready var saturn: TextureButton = $Saturn
@onready var uranus: TextureButton = $Uranus
@onready var neptune: TextureButton = $Neptune
@onready var anim_2: AnimationPlayer = $AnimationPlayer2

func _ready():
	Global.emit_signal("bgm_galaxy")
	label.hide()

func _on_back_button_pressed() -> void:
	Sfxmanager.play_button_click()
	Global.emit_signal("main_theme")
	get_tree().change_scene_to_file("res://scenes/s1.tscn")

func _on_mercury_pressed() -> void:
	if Global.mercury_unlocked:
		Global.emit_signal("bgm_mercury")
		await get_tree().create_timer(0.8).timeout
		anim.play("white_screen")
		await get_tree().create_timer(2).timeout
		Global.scene_from = "mercury"
		get_tree().change_scene_to_file("res://scenes/transition.tscn")
	else:
		var offset = Vector2(-30, -50)
		label.position = mercury.position + offset
		label.show()
		await get_tree().create_timer(0.5).timeout
		label.hide()

func _on_venus_pressed() -> void:
	if Global.venus_unlocked:
		Global.emit_signal("bgm_venus")
		await get_tree().create_timer(0.8).timeout
		anim.play("white_screen_venus")
		await get_tree().create_timer(2).timeout
		Global.scene_from = "venus"
		get_tree().change_scene_to_file("res://scenes/transition.tscn")
	else:
		var offset = Vector2(-30, -50)
		label.position = venus.position + offset
		label.show()
		await get_tree().create_timer(0.5).timeout
		label.hide()

func _on_earth_pressed() -> void:
	if true:
		Global.emit_signal("bgm_earth")
		pass

func _on_mars_pressed() -> void:
	if Global.mars_unlocked:
		Global.emit_signal("bgm_mars")
		await get_tree().create_timer(0.8).timeout
		anim.play("white_screen_mars")
		await get_tree().create_timer(2).timeout
		Global.scene_from = "mars"
		get_tree().change_scene_to_file("res://scenes/transition.tscn")
	else:
		var offset = Vector2(-40, -50)
		label.position = mars.position + offset
		label.show()
		await get_tree().create_timer(0.5).timeout
		label.hide()

func _on_jupiter_pressed() -> void:
	if Global.jupiter_unlocked:
		Global.emit_signal("bgm_jupiter")
		await get_tree().create_timer(0.8).timeout
		anim.play("white_screen_jupiter")
		await get_tree().create_timer(2).timeout
		Global.scene_from = "jupiter"
		get_tree().change_scene_to_file("res://scenes/transition.tscn")
	else:
		var offset = Vector2(20, -50)
		label.position = jupiter.position + offset
		label.show()
		await get_tree().create_timer(0.5).timeout
		label.hide()


func _on_saturn_pressed() -> void:
	if Global.saturn_unlocked:
		Global.emit_signal("bgm_saturn")
		await get_tree().create_timer(0.8).timeout
		anim.play("white_screen_saturn")
		await get_tree().create_timer(2).timeout
		Global.scene_from = "saturn"
		get_tree().change_scene_to_file("res://scenes/transition.tscn")
	else:
		var offset = Vector2(20, -50)
		label.position = saturn.position + offset
		label.show()
		await get_tree().create_timer(0.5).timeout
		label.hide()

func _on_uranus_pressed() -> void:
	if Global.uranus_unlocked:
		Global.emit_signal("bgm_uranus")
		await get_tree().create_timer(0.8).timeout
		anim_2.play("white_screen_uranus")
		await get_tree().create_timer(2).timeout
		Global.scene_from = "uranus"
		get_tree().change_scene_to_file("res://scenes/transition.tscn")
	else:
		var offset = Vector2(-10, -50)
		label.position = uranus.position + offset
		label.show()
		await get_tree().create_timer(0.5).timeout
		label.hide()


func _on_neptune_pressed() -> void:
	if Global.neptune_unlocked:
		Global.emit_signal("bgm_neptune")
		await get_tree().create_timer(0.8).timeout
		anim_2.play("white_screen_neptune")
		await get_tree().create_timer(2).timeout
		Global.scene_from = "neptune"
		get_tree().change_scene_to_file("res://scenes/transition.tscn")
	else:
		var offset = Vector2(0, -30)
		label.position = neptune.position + offset
		label.show()
		await get_tree().create_timer(0.5).timeout
		label.hide()
