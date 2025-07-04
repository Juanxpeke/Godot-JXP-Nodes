@tool
class_name JXP_EditorMain extends VBoxContainer
## Plugin's main screen.
##
## This panel should be shown in the central part of the editor, next to the [b]2D[/b], [b]3D[/b],
## [b]Script[/b], [b]Game[/b], and [b]AssetLib[/b] buttons.

#region Signals
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
var _editor_toolbar : HBoxContainer = null
var _editor_app_container : VBoxContainer = null

var _editor_desktop : JXP_EditorDesktop = null
var _editor_settings : JXP_EditorSettings = null
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _init() -> void:
	add_theme_constant_override("separation", 0)
	
	var toolbar_margin := MarginContainer.new()
	toolbar_margin.add_theme_constant_override("margin_left", 4 * EditorInterface.get_editor_scale())
	toolbar_margin.add_theme_constant_override("margin_right", 4 * EditorInterface.get_editor_scale())
	add_child(toolbar_margin);
	
	_editor_toolbar = HBoxContainer.new()
	toolbar_margin.add_child(_editor_toolbar)
	
	_editor_app_container = VBoxContainer.new()
	_editor_app_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(_editor_app_container)
	
	_editor_desktop = JXP_EditorDesktop.new()
	_editor_desktop.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_editor_desktop.app_selected.connect(_on_desktop_app_selected)
	_editor_app_container.add_child(_editor_desktop)
	
	_editor_settings = JXP_EditorSettings.new()
	_editor_settings.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_editor_app_container.add_child(_editor_settings)
	
	var settings_button_icon = EditorInterface.get_editor_theme().get_icon("GDScript", "EditorIcons")
	_editor_desktop.register_app(settings_button_icon, "Settings", _editor_settings)
	_register_toolbar_app(settings_button_icon, "Settings", _editor_settings)
	
	var home_button := Button.new()
	home_button.text = "JXP Nodes"
	home_button.flat = true
	home_button.size_flags_horizontal = Control.SIZE_SHRINK_END | Control.SIZE_EXPAND
	home_button.pressed.connect(_open_app.bind(_editor_desktop))
	home_button.add_theme_font_override("font", EditorInterface.get_editor_theme().get_font("bold", "EditorFonts"))
	home_button.set_theme_type_variation("FlatMenuButton")
	_editor_toolbar.add_child(home_button)
	
	_open_app(_editor_desktop)
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#region Callbacks
func _on_desktop_app_selected(control : Control) -> void:
	_open_app(control)
#endregion Callbacks

func _open_app(control : Control) -> void:
	for child in _editor_app_container.get_children():
		child.visible = false
	control.visible = true
	
func _register_toolbar_app(icon_texture : Texture2D, text : String, control : Control) -> void:
	var app_button := Button.new()
	app_button.icon = icon_texture
	app_button.flat = true
	app_button.toggle_mode = false
	app_button.tooltip_text = text
	app_button.pressed.connect(_open_app.bind(control))
	app_button.set_theme_type_variation("FlatButton")
	_editor_toolbar.add_child(app_button)
#endregion Private Methods
