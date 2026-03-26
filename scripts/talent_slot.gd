extends TextureButton
class_name TalentSlot

const DEFAULT_LINE_COLOR = Color("404040")
const ACTIVE_LINE_COLOR = Color("5df2ff")
const MAXED_COLOR = Color("ffd700")
const MAXED_LINE_COLOR = Color("00acb7ff")
const HIDDEN_LINE_COLOR = Color(0.3, 0, 0, 0.1)
const HIGHLIGHT_FULL = Color.CYAN
const HIDDEN_GLOW_COLOR = Color(1.0, 0.2, 0.2, 0.6)

enum ConnectionEdge { TOP, BOTTOM, LEFT, RIGHT }

var consumer_connection_edge: ConnectionEdge = ConnectionEdge.TOP
var provider_connection_edges: Dictionary = {}

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

enum Edge { TOP, BOTTOM, LEFT, RIGHT }

func _ready() -> void:
	mouse_filter = MOUSE_FILTER_STOP
	focus_mode = FOCUS_ALL
	if disabled_panel: 
		disabled_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if tooltip_panel:
		tooltip_panel.visible = false
		var viewport = get_viewport()
		if viewport: 
			tooltip_panel.reparent.call_deferred(viewport)
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	talent_line_template.visible = false
	
	call_deferred("_add_all_dependency_lines")
	update_disabled_panel_visibility()
	load_talent_data()

func get_edge_center(edge: Edge) -> Vector2:
	var center_x = global_position.x + size.x / 2.0
	var center_y = global_position.y + size.y / 2.0
	
	var offset = 0
	
	match edge:
		Edge.TOP:
			return Vector2(center_x, global_position.y - offset)
		Edge.BOTTOM:
			return Vector2(center_x, global_position.y + size.y + offset)
		Edge.LEFT:
			return Vector2(global_position.x - offset, center_y)
		Edge.RIGHT:
			return Vector2(global_position.x + size.x + offset, center_y)
		_:
			return Vector2(center_x, center_y)
func get_relative_position(edge: Edge) -> Vector2:
	match edge:
		Edge.TOP:
			return Vector2(0.5, 0.0)
		Edge.BOTTOM:
			return Vector2(0.5, 1.0)
		Edge.LEFT:
			return Vector2(0.0, 0.5)
		Edge.RIGHT:
			return Vector2(1.0, 0.5)
		_:
			return Vector2(0.5, 0.5)

func get_opposite_edge(edge: Edge) -> Edge:
	match edge:
		Edge.TOP:
			return Edge.BOTTOM
		Edge.BOTTOM:
			return Edge.TOP
		Edge.LEFT:
			return Edge.RIGHT
		Edge.RIGHT:
			return Edge.LEFT
		_:
			return Edge.TOP

func _connection_edge_to_edge(conn_edge: ConnectionEdge) -> Edge:
	match conn_edge:
		ConnectionEdge.TOP:
			return Edge.TOP
		ConnectionEdge.BOTTOM:
			return Edge.BOTTOM
		ConnectionEdge.LEFT:
			return Edge.LEFT
		ConnectionEdge.RIGHT:
			return Edge.RIGHT
		_:
			return Edge.TOP

func _add_all_dependency_lines():
	var all_deps = []
	for t in depends_on: 
		all_deps.append({"node": t, "hidden": false})
	for t in hidden_depends_on: 
		all_deps.append({"node": t, "hidden": true})
	
	for dep in all_deps:
		if not is_instance_valid(dep.node): 
			continue

		var provider = dep.node
		var consumer = self
		
		var provider_edge = Edge.TOP
		var consumer_edge = consumer_connection_edge
		
		var provider_override_key = provider.name
		if provider_connection_edges.has(provider_override_key):
			var override_conn_edge: ConnectionEdge = provider_connection_edges[provider_override_key]
			provider_edge = _connection_edge_to_edge(override_conn_edge)
		else:
			provider_edge = Edge.RIGHT
		
		consumer_edge = _connection_edge_to_edge(consumer_connection_edge)
		
		var from_point = provider.get_edge_center(provider_edge)
		var to_point = consumer.get_edge_center(consumer_edge)
		
		var line: Line2D = talent_line_template.duplicate()
		get_parent().add_child(line)
		get_parent().move_child(line, 0)
		
		line.clear_points()
		line.add_point(from_point)
		
		if not is_equal_approx(from_point.x, to_point.x) and not is_equal_approx(from_point.y, to_point.y):
			line.add_point(Vector2(to_point.x, from_point.y))
		
		line.add_point(to_point)
		
		line.visible = true
		line.z_index = -1
		line.joint_mode = Line2D.LINE_JOINT_ROUND
		
		connection_lines[provider] = {"line": line, "is_hidden": dep.hidden}
		update_line_visuals(provider)

func update_line_visuals(provider: TalentSlot):
	if not connection_lines.has(provider): 
		return
	var data = connection_lines[provider]
	var line = data.line
	
	if data.is_hidden:
		if provider.level > 0:
			var color = HIDDEN_GLOW_COLOR
			line.default_color = Color(color.r, color.g, color.b, color.a * 0.1)
			line.width = 3
		else:
			var color = HIDDEN_LINE_COLOR
			line.default_color = Color(color.r, color.g, color.b, color.a * 0.1)
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
	if tooltip_panel: 
		tooltip_panel.visible = true

func _on_mouse_exited():
	is_hovered = false
	if tooltip_panel: 
		tooltip_panel.visible = false

func update_tooltip_content():
	if not tooltip_panel: 
		return
	var t = tooltip_panel.get_node_or_null("Title")
	if t: 
		t.text = title
	var d = tooltip_panel.get_node_or_null("Description")
	if d: 
		d.text = description
	var l = tooltip_panel.get_node_or_null("LevelInfo")
	if l: 
		l.text = "Level: " + str(level) + "/" + str(max_level)

func get_dependencies_met() -> bool:
	for talent in depends_on:
		if talent.level == 0: 
			return false
	for talent in hidden_depends_on:
		if talent.level == 0: 
			return false
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
		if node is TalentSlot: 
			node.update_disabled_panel_visibility()

func can_be_increased():
	if level >= max_level: 
		return false
	if get_parent().has_method("get_points_left"):
		if get_parent().get_points_left() <= 0: 
			return false
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
