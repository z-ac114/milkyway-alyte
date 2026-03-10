extends Node2D

@onready var slot1: TextureRect = $CanvasLayer/Slot1
@onready var slot2: TextureRect = $CanvasLayer/Slot2
@onready var slot3: TextureRect = $CanvasLayer/Slot3
@onready var back_button: Button = $CanvasLayer/BackButton
@onready var map_button: Button = $CanvasLayer/MapButton
@onready var launch_1: Button = $CanvasLayer/Launch1
@onready var launch_2: Button = $CanvasLayer/Launch2
@onready var launch_3: Button = $CanvasLayer/Launch3

var unlock_screen = preload("res://scenes/unlock_ui.tscn")

var rocket_textures = [
	preload("res://assets/steelparts/steelrocket.png"),
	preload("res://assets/copperparts/copperrocket.png"),
	preload("res://assets/ironparts/ironrocket.png"),
	preload("res://assets/goldparts/goldrocket.png"),
	preload("res://assets/zincparts/zincrocket.png"),
	preload("res://assets/emeraldparts/emeraldrocket.png"),
	preload("res://assets/lapisparts/lapisrocket.png"),
	preload("res://assets/diamondparts/diamondrocket.png"),
	preload("res://assets/titaniumparts/titaniumrocket.png"),
]

var showing_indices = [0, 1, 2]

func _ready():
	update_slots()

func update_slots():
	slot1.texture = null
	slot2.texture = null
	slot3.texture = null
	
	for i in range(3):
		var slot = [slot1, slot2, slot3][i]
		var index_in_inventory = showing_indices[i]
		
		if index_in_inventory < Global.rocket_inventory.size():
			var rocket_level = Global.rocket_inventory[index_in_inventory]
			if rocket_level < rocket_textures.size():
				slot.texture = rocket_textures[rocket_level]
				slot.modulate.a = 1.0
		else:
			slot.modulate.a = 0.3

func _on_launch_1_pressed():
	launch_rocket(0)

func _on_launch_2_pressed():
	launch_rocket(1)

func _on_launch_3_pressed():
	launch_rocket(2)

func launch_rocket(slot_index: int):
	var inventory_index = showing_indices[slot_index]
	
	if inventory_index < Global.rocket_inventory.size():
		var rocket_slot = [slot1, slot2, slot3][slot_index]
		var rocket_level = Global.rocket_inventory[inventory_index]
		print("Launching rocket level " + str(rocket_level) + "!")
		animate_launch(rocket_slot, inventory_index)
	else:
		print("No rocket!")

func spawn_unlock_ui(name: String, planet_color: Color, delay_time: float):
	await get_tree().create_timer(delay_time).timeout
	var ui = unlock_screen.instantiate()
	ui.text_color = planet_color
	ui.planet_name = name
	get_tree().root.add_child(ui)

func animate_launch(rocket_slot: TextureRect, inventory_index: int):
	var rocket_level = Global.rocket_inventory[inventory_index]
	var original_position = rocket_slot.position
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(rocket_slot, "position:y", rocket_slot.position.y - 500, 1.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(rocket_slot, "modulate:a",0.0,1.2)
	await tween.finished
	Global.rocket_inventory.remove_at(inventory_index)
	rocket_slot.position = original_position
	rocket_slot.scale = Vector2(1, 1)
	rocket_slot.modulate.a = 1.0
	showing_indices.clear()
	var next_index = 0
	for i in range(3):
		while next_index < Global.rocket_inventory.size() and next_index in showing_indices:
			next_index += 1
		if next_index < Global.rocket_inventory.size():
			showing_indices.append(next_index)
			next_index += 1
		else:
			showing_indices.append(Global.rocket_inventory.size()) 
	update_slots()
	_show_unlocks(rocket_level)

func _on_map_button_pressed() -> void:
	Sfxmanager.play_button_click()
	get_tree().change_scene_to_file("res://scenes/planetselection.tscn")


func _show_unlocks(rocket_level: int):
	var delay = 0.0
	if rocket_level >= 1 and Global.mercury_unlocked == false:
		Global.mercury_unlocked = true
		spawn_unlock_ui("Mercury", Color("e5e5e5"), delay)
		delay += 0.5
	if rocket_level >= 2 and Global.venus_unlocked == false:
		Global.venus_unlocked = true
		spawn_unlock_ui("Venus", Color("e3bb76"), delay)
		delay += 0.5
	if rocket_level >= 3 and Global.mars_unlocked == false:
		Global.mars_unlocked = true
		spawn_unlock_ui("Mars",Color("ff5733"), delay)
		delay += 0.5
	if rocket_level >= 4 and Global.jupiter_unlocked == false:
		Global.jupiter_unlocked = true
		spawn_unlock_ui("Jupiter",Color("d39c7e"), delay)
		delay += 0.5
	if rocket_level >= 5 and Global.saturn_unlocked == false:
		Global.saturn_unlocked = true
		spawn_unlock_ui("Saturn",Color("c5ab6e"), delay)
		delay += 0.5
	if rocket_level >= 6 and Global.uranus_unlocked == false:
		Global.uranus_unlocked = true
		spawn_unlock_ui("Uranus",Color("b2ffff"), delay)
		delay += 0.5
	if rocket_level >= 7 and Global.neptune_unlocked == false:
		Global.neptune_unlocked = true
		spawn_unlock_ui("Neptune",Color("3f5efb"), delay)
		delay += 0.5


func _on_back_button_pressed() -> void:
	Sfxmanager.play_button_click()
	get_tree().change_scene_to_file("res://scenes/rocket.tscn")
