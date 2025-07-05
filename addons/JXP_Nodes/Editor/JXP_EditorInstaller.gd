@tool
class_name JXP_EditorInstaller extends PanelContainer
## Plugin's installer panel.

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
# Data
var _plugin_modules : JXP_PluginModules = null
# Nodes
var _editor_inspector : EditorInspector = null
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _init() -> void:
	_plugin_modules = JXP_PluginModules.new()
	
	add_theme_stylebox_override("panel", _get_panel_style_box())
	
	var main_vb = VBoxContainer.new()
	main_vb.alignment = BoxContainer.ALIGNMENT_BEGIN
	main_vb.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(main_vb)

	_editor_inspector = EditorInspector.new()
	_editor_inspector.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_editor_inspector.property_edited.connect(_on_editor_inspector_property_edited)
	_editor_inspector.restart_requested.connect(func(): ) # TODO
	main_vb.add_child(_editor_inspector, true)
	
	var _apply_button = Button.new()
	_apply_button.text = "Save and Reload"
	_apply_button.pressed.connect(_plugin_modules.save_cached_values)
	main_vb.add_child(_apply_button)
	
	_editor_inspector.edit(_plugin_modules)
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#region Callbacks
func _on_editor_inspector_property_edited(property : String) -> void:
	pass
#endregion Callbacks
func _get_panel_style_box() -> StyleBox:
	# TODO: Godot Engine defines this as a global style box, that is used in multiple instances
	var panel_style_box := StyleBoxEmpty.new()
	panel_style_box.content_margin_left = 4
	panel_style_box.content_margin_top = 4
	panel_style_box.content_margin_right = 4
	panel_style_box.content_margin_bottom = 4
	return panel_style_box
#endregion Private Methods
