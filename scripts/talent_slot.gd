extends TextureButton
class_name TalentSlot


const DEFAULT_LINE_COLOR = Color("808080")

@export var talent_id: String
@export var tier: int = 1
@export var max_level: int = 1
@export var depends_on : Array[TalentSlot]

@onready var label: Label = $MarginContainer/Label
@onready var disabled_panel: Panel = $DisabledPanel
@onready var talent_line: Line2D = $TalentLine

var level = 0

func _ready() -> void:
	update_disabled_panel_visibility()
	
	for talent in depends_on:
		var line: TalentLine = talent_line.duplicate()
		line.dependent_talent_id = talent.talent_id
		line.add_point(global_position + size / 2)
		line.add_point(talent.global_position + talent.size / 2)
		line.visible = true
		add_child(line)


func update_disabled_panel_visibility():
	var all_dependencies_met = true
	for talent in depends_on:
		if talent.level == 0:
			all_dependencies_met = false
			break
	
	disabled_panel.visible = len(depends_on) > 0 and not all_dependencies_met


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
