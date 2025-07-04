@tool
class_name JXP_EditorDesktop extends PanelContainer
## Plugin's desktop panel.

#region Signals
## TODO.
signal app_selected(control : Control)
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
var _apps_container : HFlowContainer = null
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _init() -> void:
	var style_box := StyleBoxFlat.new()
	style_box.bg_color = Color.from_rgba8(8, 8, 8)
	style_box.content_margin_left = 8
	style_box.content_margin_top = 24
	style_box.content_margin_right = 8
	style_box.content_margin_bottom = 24
	add_theme_stylebox_override("panel", style_box)
	
	_apps_container = HFlowContainer.new()
	_apps_container.add_theme_constant_override("h_separation", 0)
	_apps_container.add_theme_constant_override("v_separation", 12)
	add_child(_apps_container)

func _draw() -> void:
	pass
#endregion Built-in Virtual Methods

#region Public Methods
## TODO.
func register_app(icon_texture : Texture2D, text : String, control : Control) -> void:
	var app_vb := VBoxContainer.new()
	app_vb.alignment = BoxContainer.ALIGNMENT_CENTER
	app_vb.custom_minimum_size = Vector2(90, 0)
	app_vb.gui_input.connect(_on_app_input.bind(control))
	app_vb.add_theme_constant_override("separation", 2)
	_apps_container.add_child(app_vb)
	
	var app_icon := TextureRect.new()
	app_icon.texture = icon_texture
	app_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	app_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	app_icon.custom_minimum_size = Vector2(48, 48)
	app_vb.add_child(app_icon)
	
	var app_label := Label.new()
	app_label.text = text
	app_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	app_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	app_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	app_label.clip_text = true
	app_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	app_label.max_lines_visible = 2
	app_label.custom_minimum_size = Vector2(0, 48)
	app_label.add_theme_color_override("font_color", Color.WHITE)
	app_label.add_theme_constant_override("line_spacing", -2)
	app_label.add_theme_font_size_override("font_size", 13)
	app_vb.add_child(app_label)
#endregion Public Methods

#region Private Methods
#region Callbacks
func _on_app_input(event : InputEvent, control : Control) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		app_selected.emit(control)
#endregion Callbacks
#endregion Private Methods
