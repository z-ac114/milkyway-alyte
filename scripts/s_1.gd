extends Node2D
@onready var rocket_building: Button = $CanvasLayer/RocketBuilding




func _on_rocket_building_pressed() -> void:
	Sfxmanager.play_button_click()
	get_tree().change_scene_to_file("res://scenes/rocket.tscn")


func _on_back_button_pressed() -> void:
	Sfxmanager.play_button_click()
	get_tree().change_scene_to_file("res://scenes/test.tscn")


func _on_space_map_pressed() -> void:
	Sfxmanager.play_button_click()
	get_tree().change_scene_to_file("res://scenes/planetselection.tscn")


func _on_rocket_site_pressed() -> void:
	Sfxmanager.play_button_click()
	get_tree().change_scene_to_file("res://scenes/rocketlaunch.tscn")
