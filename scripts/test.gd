extends Node2D
@onready var label: Label = $CanvasLayer/Label
@onready var audio_stream_player: AudioStreamPlayer = $CanvasLayer/AudioStreamPlayer
func _ready() -> void:
	Global.play_bgm = true
	
func _on_button_pressed() -> void:
	Sfxmanager.play_button_click()
	Global.play_bgm = true
	if not Global.tutorial_finished:
		get_tree().change_scene_to_file("res://scenes/tutorial.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/s1.tscn")
	
func _on_quit_game_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	Sfxmanager.play_button_click()
	Global.play_bgm = true
	get_tree().change_scene_to_file("res://scenes/credits.tscn")


func _on_settings_pressed() -> void:
	Sfxmanager.play_button_click()
	Global.emit_signal("main_theme")
	Global.play_bgm = true
	get_tree().change_scene_to_file("res://scenes/SettingsMenu.tscn")
