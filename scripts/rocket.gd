extends Node2D

@onready var back_button: Button = $BackButton
@onready var upgrade_plating_button: Button = $UpgradePlatingButton
@onready var upgrade_engine_button: Button = $UpgradeEngineButton
@onready var upgrade_fins_button: Button = $UpgradeFinsButton
@onready var upgrade_topcone_button: Button = $UpgradeTopConeButton
@onready var upgrade_tank_button: Button = $UpgradeTankButton
@onready var craft_button: Button = $CraftButton
@onready var launch_button: Button = $LaunchButton

@onready var plating_1: TextureRect = $Plating1
@onready var plating_2: TextureRect = $Plating2
@onready var fins_1: TextureRect = $Fins1
@onready var fins_2: TextureRect = $Fins2
@onready var engine_1: TextureRect = $Engine1
@onready var tank_1: TextureRect = $Tank1
@onready var tank_2: TextureRect = $Tank2
@onready var top_cone_1: TextureRect = $TopCone1
@onready var plating_cost: RichTextLabel = $PlatingCost
@onready var engine_cost: RichTextLabel = $EngineCost
@onready var fins_cost: RichTextLabel = $FinsCost
@onready var tank_cost: RichTextLabel = $TankCost
@onready var topcone_cost: RichTextLabel = $TopconeCost
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rocket: TextureRect = $Rocket

var base_rocket_parts = {
	"plating": {"costs":[
		{"copper":10},
		{"iron":15,"copper":10},
		{"gold":20,"iron":15},
		{"zinc":25,"gold":20},
		{"emerald":30,"zinc":25},
		{"lapis":35,"emerald":30},
		{"diamond":40,"lapis":35},
		{"titanium":50,"diamond":60}
	]},
	"engine": {"costs":[
		{"copper":12},
		{"iron":18,"copper":12},
		{"gold":24,"iron":18},
		{"zinc":30,"gold":24},
		{"emerald":36,"zinc":30},
		{"lapis":42,"emerald":36},
		{"diamond":50,"lapis":42},
		{"titanium":70,"diamond":50}
	]},
	"fins": {"costs":[
		{"copper":16},
		{"iron":24,"copper":16},
		{"gold":32,"iron":24},
		{"zinc":40,"gold":32},
		{"emerald":48,"zinc":40},
		{"lapis":56,"emerald":48},
		{"diamond":64,"lapis":56},
		{"titanium":82,"lapis":70}
	]},
	"topcone": {"costs":[
		{"copper":14},
		{"iron":20,"copper":14},
		{"gold":26,"iron":20},
		{"zinc":32,"gold":26},
		{"emerald":38,"zinc":32},
		{"lapis":44,"emerald":38},
		{"diamond":50,"lapis":44},
		{"titanium":60,"lapis":50}
	]},
	"tank": {"costs":[
		{"copper":32},
		{"iron":44,"copper":32},
		{"gold":56,"iron":44},
		{"zinc":68,"gold":56},
		{"emerald":80,"zinc":68},
		{"lapis":92,"emerald":80},
		{"diamond":104,"lapis":92},
		{"titanium":120,"lapis":100}
	]}
}

var rocket_parts = {}

var plating_textures = [
	preload("res://assets/steelparts/steelplate.png"),
	preload("res://assets/copperparts/copperplate.png"),
	preload("res://assets/ironparts/ironplate.png"),
	preload("res://assets/goldparts/goldplate.png"),
	preload("res://assets/zincparts/zincplate.png"),
	preload("res://assets/emeraldparts/emeraldplate.png"),
	preload("res://assets/lapisparts/lapisplate.png"),
	preload("res://assets/diamondparts/diamondplate.png"),
	preload("res://assets/titaniumparts/titaniumplate.png")
]

var fins_textures = [
	preload("res://assets/steelparts/steelfin.png"),
	preload("res://assets/copperparts/copperfin.png"),
	preload("res://assets/ironparts/ironfin.png"),
	preload("res://assets/goldparts/goldfin.png"),
	preload("res://assets/zincparts/zincfin.png"),
	preload("res://assets/emeraldparts/emeraldfin.png"),
	preload("res://assets/lapisparts/lapisfin.png"),
	preload("res://assets/diamondparts/diamondfin.png"),
	preload("res://assets/titaniumparts/titaniumfin.png")
]

var engine_textures = [
	preload("res://assets/steelparts/steelengine.png"),
	preload("res://assets/copperparts/copperengine.png"),
	preload("res://assets/ironparts/ironengine.png"),
	preload("res://assets/goldparts/goldengine.png"),
	preload("res://assets/zincparts/zincengine.png"),
	preload("res://assets/emeraldparts/emeraldengine.png"),
	preload("res://assets/lapisparts/lapisengine.png"),
	preload("res://assets/diamondparts/diamondengine.png"),
	preload("res://assets/titaniumparts/titaniumengine.png")
]

var tank_textures = [
	preload("res://assets/steelparts/steeltank.png"),
	preload("res://assets/copperparts/coppertank.png"),
	preload("res://assets/ironparts/irontank.png"),
	preload("res://assets/goldparts/goldtank.png"),
	preload("res://assets/zincparts/zinctank.png"),
	preload("res://assets/emeraldparts/emeraldtank.png"),
	preload("res://assets/lapisparts/lapistank.png"),
	preload("res://assets/diamondparts/diamondtank.png"),
	preload("res://assets/titaniumparts/titaniumtank.png")
]

var top_cone_textures = [
	preload("res://assets/steelparts/steeltopcone.png"),
	preload("res://assets/copperparts/coppertopcone.png"),
	preload("res://assets/ironparts/irontopcone.png"),
	preload("res://assets/goldparts/goldtopcone.png"),
	preload("res://assets/zincparts/zinctopcone.png"),
	preload("res://assets/emeraldparts/emeraldtopcone.png"),
	preload("res://assets/lapisparts/lapistopcone.png"),
	preload("res://assets/diamondparts/diamondtopcone.png"),
	preload("res://assets/titaniumparts/titaniumtopcone.png")
]

var rocket_textures = [
	preload("res://assets/steelparts/steelrocket.png"),
	preload("res://assets/copperparts/copperrocket.png"),
	preload("res://assets/ironparts/ironrocket.png"),
	preload("res://assets/goldparts/goldrocket.png"),
	preload("res://assets/zincparts/zincrocket.png"),
	preload("res://assets/emeraldparts/emeraldrocket.png"),
	preload("res://assets/lapisparts/lapisrocket.png"),
	preload("res://assets/diamondparts/diamondrocket.png"),
	preload("res://assets/titaniumparts/titaniumrocket.png")
]

func _ready() -> void:
	reset_costs_to_base()
	
	upgrade_plating_button.pressed.connect(_on_upgrade_plating_pressed)
	upgrade_engine_button.pressed.connect(_on_upgrade_engine_pressed)
	upgrade_fins_button.pressed.connect(_on_upgrade_fins_pressed)
	upgrade_topcone_button.pressed.connect(_on_upgrade_topcone_pressed)
	upgrade_tank_button.pressed.connect(_on_upgrade_tank_pressed)
	craft_button.pressed.connect(_on_craft_pressed)
	_update_textures()
	rocket.visible = false

func reset_costs_to_base():
	rocket_parts = {}
	for part in base_rocket_parts:
		rocket_parts[part] = {"costs": []}
		for tier_cost in base_rocket_parts[part]["costs"]:
			var cost_copy = {}
			for material in tier_cost:
				cost_copy[material] = tier_cost[material]
			rocket_parts[part]["costs"].append(cost_copy)

func calculate_price_multiplier() -> float:
	var rocket_count = Global.rocket_inventory.size()
	var base_multiplier = pow(1.2, rocket_count)
	
	var has_tier_8 = false
	for rocket_level in Global.rocket_inventory:
		if rocket_level == 8:
			has_tier_8 = true
			break
	
	var tier_8_multiplier = 2.0 if has_tier_8 else 1.0
	
	return base_multiplier * tier_8_multiplier

func apply_price_multiplier():
	var multiplier = calculate_price_multiplier()
	
	reset_costs_to_base()
	
	for part in rocket_parts:
		for tier_index in range(rocket_parts[part]["costs"].size()):
			var tier_cost = rocket_parts[part]["costs"][tier_index]
			for material in tier_cost.keys():
				var base_value = base_rocket_parts[part]["costs"][tier_index][material]
				tier_cost[material] = ceil(base_value * multiplier)

func _update_textures():
	plating_1.texture = plating_textures[Global.rocket_levels["plating"]]
	plating_2.texture = plating_textures[Global.rocket_levels["plating"]]
	fins_1.texture = fins_textures[Global.rocket_levels["fins"]]
	fins_2.texture = fins_textures[Global.rocket_levels["fins"]]
	engine_1.texture = engine_textures[Global.rocket_levels["engine"]]
	tank_1.texture = tank_textures[Global.rocket_levels["tank"]]
	tank_2.texture = tank_textures[Global.rocket_levels["tank"]]
	top_cone_1.texture = top_cone_textures[Global.rocket_levels["topcone"]]
	_update_cost_display()

func _update_cost_display():
	update_specific_cost("plating", plating_cost)
	update_specific_cost("engine", engine_cost) 
	update_specific_cost("fins", fins_cost)
	update_specific_cost("tank", tank_cost) 
	update_specific_cost("topcone", topcone_cost)  

func update_specific_cost(part_name: String, label_node: RichTextLabel):
	var level = Global.rocket_levels[part_name]
	var costs_list = rocket_parts[part_name]["costs"]
	var nbsp = "\u00A0" 
	
	if level < costs_list.size():
		var next_cost = costs_list[level]
		var cost_string = ""
		for material in next_cost.keys():
			var amount = next_cost[material]
			var icon_path = ""
			match material:
				"rock": icon_path = "res://assets/rockk.png"
				"copper": icon_path = "res://assets/copperparts/copperingot.png"
				"iron": icon_path = "res://assets/ironparts/ironingot.png"
				"gold": icon_path = "res://assets/goldparts/goldingot.png"
				"zinc": icon_path = "res://assets/zincparts/zincingot.png"
				"emerald": icon_path = "res://assets/emeraldparts/emeraldd.png"
				"lapis": icon_path = "res://assets/lapisparts/lapislazuli.png"
				"diamond": icon_path = "res://assets/diamondparts/diamondd.png"
				"titanium": icon_path = "res://assets/titaniumparts/titaniumingot.png"
			var color_tag = "[color=red]" if Global.get(material) < amount else ""
			var end_tag = "[/color]" if color_tag != "" else ""
			cost_string += "[img=26]%s[/img]%s%s%s%s  " % [icon_path, nbsp, color_tag, str(amount), end_tag]
		label_node.text = cost_string
	else:
		label_node.text = part_name.capitalize() + ": [color=#FFD700]MAX[/color]"

func upgrade_part(part_name: String):
	var level = Global.rocket_levels[part_name]
	var costs = rocket_parts[part_name]["costs"]
	if level >= costs.size(): return
	var cost = costs[level]
	if can_afford(cost):
		deduct_cost(cost)
		_update_textures()
		var animation_name = get_upgrade_animation(part_name, level)
		Global.rocket_levels[part_name] += 1
		if animation_name != "":
			print("Playing animation: ", animation_name)
			animation_player.play(animation_name)
			await animation_player.animation_finished
		else:
			print("No animation for upgrade from level ", level)
		
		_update_textures()

func get_upgrade_animation(part_name: String, current_level: int) -> String:
	match part_name:
		"fins":
			match current_level:
				0:
					return "steeltocopperfin"
				1:
					return "coppertoironfin"
				2:
					return "irontogoldfin"
				3:
					return "goldtozincfin"
				4:
					return "zinctoemeraldfin"
				5: 
					return "emeraldtolapisfin"
				6:
					return "lapistodiamondfin"
				_:
					return ""
				
		"plating":
			match current_level:
				0:
					return "steeltocopperplating"
				1:
					return "coppertoironplating"
				2:
					return "irontogoldplating"
				3:
					return "goldtozincplating"
				4:
					return "zinctoemeraldplating"
				5:
					return "emeraldtolapisplating"
				6:
					return "lapistodiamondplating"
				_:
					return ""
		"tank":
			match current_level:
				0:
					return "steeltocoppertank"
				_:
					return ""
		_:
			return ""
			
func can_afford(cost: Dictionary) -> bool:
	for material in cost.keys():
		if Global.get(material) < cost[material]: return false
	return true

func deduct_cost(cost: Dictionary):
	for material in cost.keys():
		Global.set(material, Global.get(material) - cost[material])

func _on_craft_pressed() -> void:
	var levels = rocket_parts.keys().map(func(p): return Global.rocket_levels[p])
	var all_same = levels.all(func(l): return l == levels[0])
	
	if all_same and levels[0] > 0:
		start_crafting_animation(levels[0])

func start_crafting_animation(level: int):
	rocket.texture = rocket_textures[level]
	Global.rocket_inventory.append(level)
	craft_button.disabled = true
	animation_player.play("craft_rocket")
	rocket.show()
	
	await animation_player.animation_finished
	_finish_crafting()

func _finish_crafting():
	for part_name in rocket_parts.keys():
		Global.rocket_levels[part_name] = 0
	
	apply_price_multiplier()
	
	_update_textures()
	rocket.visible = false
	craft_button.disabled = false
	
	var parts = [plating_1, plating_2, fins_1, fins_2, engine_1, tank_1, tank_2, top_cone_1]
	for p in parts:
		p.visible = true
		p.modulate.a = 1.0

func _on_back_button_pressed() -> void:
	Sfxmanager.play_button_click()
	get_tree().change_scene_to_file("res://scenes/s1.tscn")

func _on_launch_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/rocketlaunch.tscn")

func _on_upgrade_plating_pressed(): upgrade_part("plating")
func _on_upgrade_engine_pressed(): upgrade_part("engine")
func _on_upgrade_fins_pressed(): upgrade_part("fins")
func _on_upgrade_topcone_pressed(): upgrade_part("topcone")
func _on_upgrade_tank_pressed(): upgrade_part("tank")
