extends Control
class_name TalentTree

@onready var points_label: Label = $PointsLabel
@onready var cost: RichTextLabel = $Cost


func _ready() -> void:
	set_points_label()
	setup_points()
	update_cost_display()

func setup_points():
	for talent in get_children():
		if talent is TalentSlot:
			talent.set_label()


func get_points_left():
	var points_spent = 0
	for talent in get_children():
		if talent is TalentSlot:
			points_spent += talent.level
	return Global.research_coins - points_spent
	

func set_points_label():
	points_label.text = str(get_points_left())


func _on_button_pressed() -> void:
	var base_cost = 100
	var scaling_factor = 1.15
	
	var current_cost = base_cost * pow(scaling_factor, Global.research_coins)
	
	var rock_cost = current_cost
	var copper_cost = current_cost * 0.5
	var iron_cost = current_cost * 0.3
	
	if Global.rock >= rock_cost and Global.copper >= copper_cost and Global.iron >= iron_cost:
		Global.rock -= rock_cost
		Global.copper -= copper_cost
		Global.iron -= iron_cost
		
		Global.research_coins += 1
		
		set_points_label()
		update_cost_display()
		
		print("Purchased research coin!")
		print("Cost breakdown - Rock: ", rock_cost, " Copper: ", copper_cost, " Iron: ", iron_cost)
	else:
		print("Insufficient minerals!")

func update_cost_display() -> void:
	var base_cost = 100
	var scaling_factor = 1.15
	var current_cost = base_cost * pow(scaling_factor, Global.research_coins)
	
	var rock_cost = current_cost
	var copper_cost = current_cost * 0.5
	var iron_cost = current_cost * 0.3
	
	var nbsp = "\u00A0"
	var line = ""
	
	var can_afford_rock = Global.rock >= rock_cost
	var can_afford_copper = Global.copper >= copper_cost
	var can_afford_iron = Global.iron >= iron_cost
	
	line += "[img=16]res://assets/rockk.png[/img]%s" % nbsp
	if can_afford_rock:
		line += "%s    " % Global.f_n(rock_cost)
	else:
		line += "[color=red]%s[/color]    " % Global.f_n(rock_cost)
	
	line += "[img=16]res://assets/copperparts/copperingot.png[/img]%s" % nbsp
	if can_afford_copper:
		line += "%s    " % Global.f_n(copper_cost)
	else:
		line += "[color=red]%s[/color]    " % Global.f_n(copper_cost)
	
	line += "[img=16]res://assets/ironparts/ironingot.png[/img]%s" % nbsp
	if can_afford_iron:
		line += "%s" % Global.f_n(iron_cost)
	else:
		line += "[color=red]%s[/color]" % Global.f_n(iron_cost)
	
	cost.text = line


func _on_button_2_pressed() -> void:
	Sfxmanager.play_button_click()
	get_tree().change_scene_to_file("res://scenes/s1.tscn")
