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
var _tool_buttons : Array[Button] = []
var _editor_toolbar : HBoxContainer = null
var _editor_app_container : VBoxContainer = null

var _editor_home : JXP_EditorHome = null
var _editor_installer : JXP_EditorInstaller = null
var _editor_settings : JXP_EditorSettings = null
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _init() -> void:
	var toolbar_margin := MarginContainer.new()
	toolbar_margin.add_theme_constant_override("margin_left", 4 * EditorInterface.get_editor_scale())
	toolbar_margin.add_theme_constant_override("margin_right", 4 * EditorInterface.get_editor_scale())
	add_child(toolbar_margin);
	
	_editor_toolbar = HBoxContainer.new()
	toolbar_margin.add_child(_editor_toolbar)
	
	_editor_app_container = VBoxContainer.new()
	_editor_app_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(_editor_app_container)
	
	_editor_home = JXP_EditorHome.new()
	_editor_home.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_editor_app_container.add_child(_editor_home)
	
	var home_button := Button.new()
	home_button.text = "JXP Nodes"
	home_button.flat = true
	home_button.toggle_mode = true
	home_button.theme_type_variation = "FlatMenuButton"
	home_button.pressed.connect(_on_app_button_pressed.bind(_editor_home, 0))
	home_button.add_theme_font_override("font", EditorInterface.get_editor_theme().get_font("bold", "EditorFonts"))
	_editor_toolbar.add_child(home_button)
	_tool_buttons.push_back(home_button)
	
	_editor_toolbar.add_child(VSeparator.new())
	
	_editor_installer = JXP_EditorInstaller.new()
	_editor_settings = JXP_EditorSettings.new()
	
	_register_app("AssetLib", "Installer", _editor_installer)
	_register_app("GDScript", "Settings", _editor_settings)
	
	_open_app(_editor_home)

func _notification(what : int) -> void:
	if what == NOTIFICATION_THEME_CHANGED:
		for button : Button in _tool_buttons:
			if not button.has_meta("icon_name"):
				continue
			var icon_name : String = button.get_meta("icon_name")
			button.icon = EditorInterface.get_editor_theme().get_icon(icon_name, "EditorIcons")
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func _on_app_button_pressed(control : Control, tool_button_index : int) -> void:
	for i in _tool_buttons.size():
		_tool_buttons[i].button_pressed = (i == tool_button_index)
	_open_app(control)

func _open_app(control : Control) -> void:
	for child in _editor_app_container.get_children():
		child.visible = false
	control.visible = true

func _register_app(icon_name : String, text : String, control : Control) -> void:
	control.size_flags_vertical = Control.SIZE_EXPAND_FILL
	if not control in _editor_app_container.get_children():
		_editor_app_container.add_child(control)
	
	var app_button := Button.new()
	app_button.icon = EditorInterface.get_editor_theme().get_icon(icon_name, "EditorIcons")
	app_button.toggle_mode = true
	app_button.tooltip_text = text
	app_button.theme_type_variation = "FlatButton"
	app_button.pressed.connect(_on_app_button_pressed.bind(control, _tool_buttons.size()))
	app_button.set_meta("icon_name", icon_name)
	_editor_toolbar.add_child(app_button)
	_tool_buttons.push_back(app_button)
#endregion Private Methods
