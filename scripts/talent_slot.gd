extends TextureButton
class_name TalentSlot

const DEFAULT_LINE_COLOR = Color("808080")
const MAXED_COLOR = Color("ffd700")

@export var talent_id: String
@export var tier: int = 1
@export var max_level: int = 1
@export var depends_on : Array[TalentSlot]
@export var title: String = ""
@export var description: String = ""

@onready var label: Label = $MarginContainer/Label
@onready var disabled_panel: Panel = $DisabledPanel
@onready var talent_line: Line2D = $TalentLine
@onready var tooltip_panel: Panel = $TooltipPanel

var level = 0
var is_hovered = false
var hover_timer: Timer

func _ready() -> void:
	
	update_disabled_panel_visibility()
	
	mouse_filter = MOUSE_FILTER_STOP
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	disabled = false
	focus_mode = FOCUS_ALL
	
	if disabled_panel:
		disabled_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	hover_timer = Timer.new()
	hover_timer.name = "HoverTimer"
	hover_timer.one_shot = true
	hover_timer.wait_time = 0.5
	add_child(hover_timer)
	hover_timer.timeout.connect(_on_hover_timer_timeout)
	
	if tooltip_panel:
		tooltip_panel.visible = false
		tooltip_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		var title_label = tooltip_panel.get_node_or_null("Title")
		var desc_label = tooltip_panel.get_node_or_null("Description")
		var level_label = tooltip_panel.get_node_or_null("LevelInfo")
		
		print("Tooltip panel children - Title: ", title_label != null, 
			  " Desc: ", desc_label != null, 
			  " Level: ", level_label != null)
		
		var viewport = get_viewport()
		if viewport:
			tooltip_panel.reparent.call_deferred(viewport)
	
	if not mouse_entered.is_connected(_on_mouse_entered):
		mouse_entered.connect(_on_mouse_entered)
	if not mouse_exited.is_connected(_on_mouse_exited):
		mouse_exited.connect(_on_mouse_exited)
	
	call_deferred("_add_dependency_lines")

func _add_dependency_lines():
	for talent in depends_on:
		if not is_instance_valid(talent):
			continue
			
		var line: TalentLine = talent_line.duplicate()
		line.dependent_talent_id = talent.talent_id
		line.add_point(global_position + size / 2)
		line.add_point(talent.global_position + talent.size / 2)
		line.visible = true
		add_child(line)

func _on_mouse_entered():
	is_hovered = true
	# Show tooltip immediately without waiting
	update_tooltip_content()
	tooltip_panel.visible = true
	# Start timer for potential delayed actions (if needed)
	if tooltip_panel and title != "" and description != "":
		hover_timer.start()

func _on_mouse_exited():
	is_hovered = false
	hover_timer.stop()
	if tooltip_panel:
		tooltip_panel.visible = false

func _on_focus_entered():
	is_hovered = true
	if tooltip_panel and title != "" and description != "":
		update_tooltip_content()
		tooltip_panel.visible = true

func _on_focus_exited():
	is_hovered = false
	if tooltip_panel:
		tooltip_panel.visible = false

func _on_hover_timer_timeout():
	# This can be used for additional delayed behavior if needed
	# Currently just updates content again
	if is_hovered and tooltip_panel:
		update_tooltip_content()
		
func update_tooltip_content():
	if not tooltip_panel:
		return
	
	var title_label = tooltip_panel.get_node_or_null("Title")
	if title_label:
		title_label.text = title
	
	var desc_label = tooltip_panel.get_node_or_null("Description")
	if desc_label:
		desc_label.text = description
	
	var level_label = tooltip_panel.get_node_or_null("LevelInfo")
	if level_label:
		level_label.text = "Level: " + str(level) + "/" + str(max_level)

func get_dependencies_met() -> bool:
	for talent in depends_on:
		if talent.level == 0:
			return false
	return true

func update_disabled_panel_visibility():
	if level >= max_level:
		disabled_panel.visible = true
		disabled_panel.modulate = MAXED_COLOR
		disabled_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		return
	
	var all_dependencies_met = get_dependencies_met()
	
	if len(depends_on) > 0 and not all_dependencies_met:
		disabled_panel.visible = true
		disabled_panel.modulate = Color.WHITE
		disabled_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		disabled_panel.visible = false

func set_label():
	label.text = str(level) + "/" + str(max_level)
	update_disabled_panel_visibility()
	
	for talent in get_parent().get_children():
		if talent is TalentSlot:
			for line in talent.get_children():
				if line is TalentLine and line.dependent_talent_id == talent_id:
					line.default_color = Color.WHITE if level > 0 else DEFAULT_LINE_COLOR

func update_dependent_slots():
	for talent in get_parent().get_children():
		if talent is TalentSlot and talent != self:
			if self in talent.depends_on:
				talent.update_disabled_panel_visibility()

func can_be_increased():
	if level >= max_level:
		return false
		
	var result = get_parent().get_points_left() > 0
	for talent in depends_on:
		if talent.level == 0:
			result = false
	return result

func set_new_level(next_level: int):
	var old_level = level
	level = clamp(next_level, 0, max_level)
	set_label()
	get_parent().set_points_label()
	
	if old_level == 0 and level > 0:
		update_dependent_slots()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		var next_level = level
		if event.button_index == MOUSE_BUTTON_LEFT and can_be_increased():
			next_level += 1
		set_new_level(next_level)
