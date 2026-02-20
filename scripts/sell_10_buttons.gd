extends VBoxContainer

var sell_rates := {
	"rock": 1.0,
	"copper": 2.0,
	"iron": 5.0,
	"gold": 10.0,
	"zinc": 15.0,
	"emerald": 25.0,
	"lapis": 30.0
}

@onready var sell_10_rock: Button = $Sell10Rock
@onready var sell_10_copper: Button = $Sell10Copper
@onready var sell_10_iron: Button = $Sell10Iron
@onready var sell_10_gold: Button = $Sell10Gold
@onready var sell_10_zinc: Button = $Sell10Zinc
@onready var sell_10_emerald: Button = $Sell10Emerald
@onready var sell_10_lapis: Button = $Sell10Lapis
@onready var sell_10_diamond: Button = $Sell10Diamond


func _ready():
	sell_10_rock.pressed.connect(func(): _sell_item("rock", 10))
	sell_10_copper.pressed.connect(func(): _sell_item("copper", 10))
	sell_10_iron.pressed.connect(func(): _sell_item("iron", 10))
	sell_10_gold.pressed.connect(func(): _sell_item("gold", 10))
	sell_10_zinc.pressed.connect(func(): _sell_item("zinc", 10))
	sell_10_emerald.pressed.connect(func(): _sell_item("emerald", 10))
	sell_10_lapis.pressed.connect(func(): _sell_item("lapis", 10))
	sell_10_diamond.pressed.connect(func(): _sell_item("diamond", 10))

func _sell_item(item_name: String, amount: int):
	if Global.get(item_name) >= amount:
		var earnings = amount * sell_rates[item_name]
		Global.coin += earnings
		
		var new_count = Global.get(item_name) - amount
		Global.set(item_name, new_count)
		
		print("Sold %d %s for %d coins" % [amount, item_name, earnings])
	else:
		print("Not enough %s!" % item_name)
