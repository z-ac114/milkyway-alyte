extends Node

var rock1mult: float = 1
var current_interval: float
var cps: float = 0.0
var rocktier: String = "rock"
var rock: float = 0
var copper: float = 0
var iron: float = 0
var gold: float = 0
var zinc: float = 0
var emerald: float = 0
var lapis: float = 0
var diamond: float = 0
var titanium: float = 0
var coin: float = 0.0
var upgrade_level: int = 0
var button_e: bool = false
var rocket_inventory = []
var music_volume_db: float = -10.0
var music_muted: bool = false  
var sfx_volume_db: float = -30.0
var sfx_muted: bool = false  
var play_bgm :bool = false
var planets: float = 0
var mercury_unlocked: bool = false
var venus_unlocked: bool = false
var mars_unlocked: bool = false
var jupiter_unlocked: bool = false
var saturn_unlocked: bool = false
var uranus_unlocked: bool = false
var neptune_unlocked: bool = false
var odyssey_played: bool = false
var tutorial_finished: bool = false
var funny_button: int = 0
var scene_from: String
var rock_mult = 1.0
var copper_mult = 1.0
var iron_mult = 1.0
var gold_mult = 1.0
var zinc_mult = 1.0
var emerald_mult = 1.0
var lapis_mult = 1.0
var diamond_mult = 1.0
var research_coins = 0
signal bgm_galaxy
signal bgm_odyssey
signal bgm_earth
signal bgm_mercury
signal bgm_venus
signal bgm_mars
signal bgm_jupiter
signal bgm_saturn
signal bgm_uranus
signal bgm_neptune
signal main_theme
signal bgm_loop
signal bgm_intro
signal advancement_unlocked(title, description)

var rocket_levels = {
	"plating": 0,
	"engine": 0,
	"fins": 0,
	"topcone": 0,
	"tank": 0
}

var advancements = {
	"first_rock": {
		"title": "Humble Beginnings",
		"desc": "You mined your very first rock!",
		"variable_name": "rock",
		"threshold": 1,
		"earned": false
	},
	"copper_age": {
		"title": "Industrialist",
		"desc": "Collect 50 copper to enter the industrial age.",
		"variable_name": "copper",
		"threshold": 50,
		"earned": false
	},
	"very_funny": {
		"title": "That was really funny",
		"desc": "Did you press a button somewhere? Now you are stuck with my peak music choice :))",
		"variable_name": "funny_button",
		"threshold": 1,
		"earned": false
	},
	"first_planet": {
		"title": "First Planet!",
		"desc": "Good job on discovering your first planet!",
		"variable_name": "mercury_unlocked",
		"threshold": true,
		"earned": false
	}
}

func _process(delta: float) -> void:
	check_advancements()
	

func _rock_1click():
	var tier_config = {
		"rock": {
			"base_range": [0.1, 1],
			"mults": {
				"rock": rock_mult
			}
		},
		"copper": {
			"base_range": [1, 2],
			"mults": {
				"rock": rock_mult,
				"copper": copper_mult * 0.8
			}
		},
		"iron": {
			"base_range": [1, 3],
			"mults": {
				"rock": rock_mult,
				"copper": copper_mult * 0.6,
				"iron": iron_mult * 0.4
			}
		},
		"gold": {
			"base_range": [2, 5],
			"mults": {
				"rock": rock_mult,
				"copper": copper_mult * 0.5,
				"iron": iron_mult * 0.35,
				"gold": gold_mult * 0.25
			}
		},
		"zinc": {
			"base_range": [3, 7],
			"mults": {
				"rock": rock_mult,
				"copper": copper_mult * 0.4,
				"iron": iron_mult * 0.3,
				"gold": gold_mult * 0.2,
				"zinc": zinc_mult * 0.15
			}
		},
		"emerald": {
			"base_range": [5, 10],
			"mults": {
				"rock": rock_mult,
				"copper": copper_mult * 0.3,
				"iron": iron_mult * 0.25,
				"gold": gold_mult * 0.2,
				"zinc": zinc_mult * 0.15,
				"emerald": emerald_mult * 0.1
			}
		},
		"lapis": {
			"base_range": [10, 20],
			"mults": {
				"rock": rock_mult,
				"copper": copper_mult * 0.25,
				"iron": iron_mult * 0.2,
				"gold": gold_mult * 0.15,
				"zinc": zinc_mult * 0.12,
				"emerald": emerald_mult * 0.08,
				"lapis": lapis_mult * 0.05
			}
		},
		"diamond": {
			"base_range": [20, 50],
			"mults": {
				"rock": rock_mult,
				"copper": copper_mult * 0.2,
				"iron": iron_mult * 0.15,
				"gold": gold_mult * 0.12,
				"zinc": zinc_mult * 0.1,
				"emerald": emerald_mult * 0.07,
				"lapis": lapis_mult * 0.05,
				"diamond": diamond_mult * 0.03
			}
		}
	}
	
	var config = tier_config.get(rocktier, tier_config["rock"])
	var base_min = config["base_range"][0]
	var base_max = config["base_range"][1]
	
	for mineral in config["mults"]:
		var amount = randf_range(base_min, base_max) * rock1mult * config["mults"][mineral]
		match mineral:
			"rock":
				rock += amount
			"copper":
				copper += amount
			"iron":
				iron += amount
			"gold":
				gold += amount
			"zinc":
				zinc += amount
			"emerald":
				emerald += amount
			"lapis":
				lapis += amount
			"diamond":
				diamond += amount

func f_n(num: float) -> String:
	if abs(num) >= 1e15:
		var exponent = log(abs(num)) / log(10)
		var base = num / pow(10, floor(exponent))
		return str(base).pad_decimals(2) + "e" + str(int(floor(exponent)))
	elif abs(num) >= 1e12:
		return str(num / 1e12).pad_decimals(1) + "T"
	elif abs(num) >= 1e9:
		return str(num / 1e9).pad_decimals(1) + "B"
	elif abs(num) >= 1e6:
		return str(num / 1e6).pad_decimals(1) + "M"
	elif abs(num) >= 1e3:
		return str(num / 1e3).pad_decimals(1) + "k"
	elif abs(num) >= 9.99:
		return str(num).pad_decimals(1)
	else:
		return str(num).pad_decimals(2)

func start_autoclick_loop():
	if button_e:
		await get_tree().create_timer(current_interval).timeout
		_rock_1click()
		start_autoclick_loop()

func check_advancements():
	for id in advancements:
		var adv = advancements[id]
		if adv["earned"]:
			continue	
		var current_val = get(adv["variable_name"])
		if current_val == null:
			continue
		var is_triggered = false
		if typeof(adv["threshold"]) == TYPE_BOOL:
			is_triggered = (current_val == adv["threshold"])
		else:
			is_triggered = (current_val >= adv["threshold"])
		if is_triggered:
			adv["earned"] = true
			emit_signal("advancement_unlocked", adv["title"], adv["desc"])
			print("Signal Emitted for: ", adv["title"])


var talent_database = {
	"iron": {
		"title": "The Foundry (I)",
		"description": "Increases Iron Production ",
		"max_level": 2
	},
	"ice_bolt": {
		"title": "Ice Bolt",
		"description": "Shoots an ice bolt that slows enemies",
		"max_level": 5
	},
	"healing_light": {
		"title": "Healing Light",
		"description": "Restores health over time",
		"max_level": 3
	}
}

func get_talent_data(talent_id: String) -> Dictionary:
	if talent_database.has(talent_id):
		return talent_database[talent_id]
	return {}
