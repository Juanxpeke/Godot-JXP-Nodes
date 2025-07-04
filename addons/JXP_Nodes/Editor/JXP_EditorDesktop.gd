@tool
class_name JXP_EditorDesktop extends PanelContainer
## Plugin's desktop panel.

#region Signals
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
var _apps_container : GridContainer = null
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _init() -> void:
	
	add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	
	_apps_container = GridContainer.new()
	add_child(_apps_container)

func _draw() -> void:
	draw_line(Vector2(0, 20), Vector2(size.x, 20), Color.DIM_GRAY)
#endregion Built-in Virtual Methods

#region Public Methods
## TODO.
func register_app(icon_texture : Texture2D, text : String, control : Control) -> void:
	var app_vb := VBoxContainer.new()
	app_vb.alignment = BoxContainer.ALIGNMENT_CENTER
	app_vb.gui_input.connect(_on_app_input.bind(control))
	_apps_container.add_child(app_vb)
	
	var app_icon := TextureRect.new()
	app_icon.custom_minimum_size = Vector2(64, 64)
	app_icon.texture = icon_texture
	app_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	app_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	app_vb.add_child(app_icon)
	
	var app_label := Label.new()
	app_label.text = text
	app_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	app_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	app_vb.add_child(app_label)
#endregion Public Methods

#region Private Methods
#region Callbacks
func _on_app_input(event : InputEvent, control : Control) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		app_selected.emit(control)
#endregion Callbacks
#endregion Private Methods
