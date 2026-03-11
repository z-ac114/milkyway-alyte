extends Button

@export var base_interval: float = 1.0
@export var base_cost: int = 10  
@export var cost_multiplier: float = 1.5  

func _ready():
	pressed.connect(_on_button_pressed)
	update_interval()
	update_text()

func _on_button_pressed():
	var cost = get_upgrade_cost()
	if float(Global.coin) >= float(cost):
		Global.coin -= float(cost)
		Global.upgrade_level += 1
		
		if Global.button_e == false:
			Global.button_e = true
			Global.start_autoclick_loop()
			
		update_interval()
		update_text()

func update_interval():
	Global.current_interval = base_interval * pow(0.95, Global.upgrade_level)

func get_upgrade_cost():
	var cost_float = float(base_cost) * pow(cost_multiplier, Global.upgrade_level)
	return cost_float

func update_text():
	if Global.button_e == false:
		text = "Auto Mine - $10" 
	else:
		text = "Upgrade - $" + Global.f_n(get_upgrade_cost())
