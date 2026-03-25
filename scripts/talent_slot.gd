extends TextureButton
class_name TalentSlot

const DEFAULT_LINE_COLOR = Color("404040")
const ACTIVE_LINE_COLOR = Color("5df2ff")
const MAXED_COLOR = Color("ffd700")
const MAXED_LINE_COLOR = Color("00acb7ff")
const HIDDEN_LINE_COLOR = Color(0.3, 0, 0, 0.1)
const HIGHLIGHT_FULL = Color.CYAN
const HIDDEN_GLOW_COLOR = Color(1.0, 0.2, 0.2, 0.6)

@export var talent_id: String
@export var max_level: int = 1 
@export var depends_on: Array[TalentSlot]
@export var hidden_depends_on: Array[TalentSlot]
@export var title: String = ""
@export var description: String = ""

@onready var label: Label = $MarginContainer/Label
@onready var disabled_panel: Panel = $DisabledPanel
@onready var talent_line_template: Line2D = $TalentLine
@onready var tooltip_panel: Panel = $TooltipPanel

var level = 0
var is_hovered = false
var connection_lines: Dictionary = {}

func _ready() -> void:
	mouse_filter = MOUSE_FILTER_STOP
	focus_mode = FOCUS_ALL
	if disabled_panel: disabled_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if tooltip_panel:
		tooltip_panel.visible = false
		var viewport = get_viewport()
		if viewport: tooltip_panel.reparent.call_deferred(viewport)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	talent_line_template.visible = false
	call_deferred("_add_all_dependency_lines")
	update_disabled_panel_visibility()
	load_talent_data()

func _add_all_dependency_lines():
	var all_deps = []
	for t in depends_on: all_deps.append({"node": t, "hidden": false})
	for t in hidden_depends_on: all_deps.append({"node": t, "hidden": true})
	
	for dep in all_deps:
		if not is_instance_valid(dep.node): continue
		
		var line: Line2D = talent_line_template.duplicate()
		get_parent().add_child(line)
		get_parent().move_child(line, 0)
		
		var parent = dep.node
		var child = self
		
		# Define clean Top-to-Bottom or Side-to-Side anchor points
		var start: Vector2
		var end: Vector2
		
		# If they are on the same Y level (side-by-side)
		if abs(parent.global_position.y - child.global_position.y) < 10:
			if parent.global_position.x < child.global_position.x:
				start = parent.global_position + Vector2(parent.size.x, parent.size.y / 2)
				end = child.global_position + Vector2(0, child.size.y / 2)
			else:
				start = parent.global_position + Vector2(0, parent.size.y / 2)
				end = child.global_position + Vector2(child.size.x, child.size.y / 2)
		else:
			# Standard Top-to-Bottom
			start = parent.global_position + Vector2(parent.size.x / 2, parent.size.y)
			end = child.global_position + Vector2(child.size.x / 2, 0)

		line.clear_points()
		line.add_point(start)
		
		# Create the structured "L" or "elbow" bend
		if abs(start.x - end.x) > 2.0 and abs(start.y - end.y) > 2.0:
			# Logic: Move vertically halfway, then horizontally, then vertically the rest
			# This creates the "branching" look from your first screenshot
			var mid_y = start.y + (end.y - start.y) / 2
			line.add_point(Vector2(start.x, mid_y))
			line.add_point(Vector2(end.x, mid_y))
		
		line.add_point(end)
		
		line.visible = true
		line.z_index = -1
		line.joint_mode = Line2D.LINE_JOINT_ROUND
		
		connection_lines[dep.node] = {"line": line, "is_hidden": dep.hidden}
		update_line_visuals(dep.node)

func update_line_visuals(provider: TalentSlot):
	if not connection_lines.has(provider): return
	var data = connection_lines[provider]
	var line = data.line
	
	if data.is_hidden:
		if provider.level > 0:
			line.default_color = HIDDEN_GLOW_COLOR
			line.width = 3
		else:
			line.default_color = HIDDEN_LINE_COLOR
			line.width = 1
	else:
		if provider.level >= provider.max_level:
			line.default_color = MAXED_LINE_COLOR
			line.width = 4
		elif provider.level > 0:
			line.default_color = HIGHLIGHT_FULL
			line.width = 3
		else:
			line.default_color = DEFAULT_LINE_COLOR
			line.width = 2

func _on_mouse_entered():
	is_hovered = true
	update_tooltip_content()
	if tooltip_panel: tooltip_panel.visible = true

func _on_mouse_exited():
	is_hovered = false
	if tooltip_panel: tooltip_panel.visible = false

func update_tooltip_content():
	if not tooltip_panel: return
	var t = tooltip_panel.get_node_or_null("Title")
	if t: t.text = title
	var d = tooltip_panel.get_node_or_null("Description")
	if d: d.text = description
	var l = tooltip_panel.get_node_or_null("LevelInfo")
	if l: l.text = "Level: " + str(level) + "/" + str(max_level)

func get_dependencies_met() -> bool:
	for talent in depends_on:
		if talent.level == 0: return false
	for talent in hidden_depends_on:
		if talent.level == 0: return false
	return true

func update_disabled_panel_visibility():
	if not disabled_panel:
		return
	
	if level >= max_level:
		disabled_panel.visible = true
		disabled_panel.modulate = MAXED_COLOR
	elif (depends_on.size() + hidden_depends_on.size()) > 0 and not get_dependencies_met():
		disabled_panel.visible = true
		disabled_panel.modulate = Color.WHITE
	else:
		disabled_panel.visible = false
	
	for talent in depends_on: 
		update_line_visuals(talent)
	for talent in hidden_depends_on: 
		update_line_visuals(talent)

func set_label():
	label.text = str(level) + "/" + str(max_level)
	update_disabled_panel_visibility()
	for node in get_parent().get_children():
		if node is TalentSlot: node.update_disabled_panel_visibility()

func can_be_increased():
	if level >= max_level: return false
	if get_parent().has_method("get_points_left"):
		if get_parent().get_points_left() <= 0: return false
	return get_dependencies_met()

func set_new_level(next_level: int):
	level = clamp(next_level, 0, max_level)
	set_label()
	if get_parent().has_method("set_points_label"):
		get_parent().set_points_label()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and can_be_increased():
			set_new_level(level + 1)

func load_talent_data() -> void:
	var data = Global.get_talent_data(talent_id)
	if not data.is_empty():
		if data.has("title"):
			title = data["title"]
		if data.has("description"):
			description = data["description"]
		if data.has("max_level"):
			max_level = data["max_level"]
			set_label()
	
	if is_hovered and tooltip_panel:
		update_tooltip_content()
