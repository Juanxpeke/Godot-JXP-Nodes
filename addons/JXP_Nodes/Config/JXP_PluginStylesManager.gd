@tool
class_name JXP_PluginStylesManager extends Object
## Static class that stores all the plugin styles information.
##
## [b]Note:[/b] This needs to be a tool script, otherwise the static variables won't be initialized.

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Static Variables
static var _thin_panel_style_box : StyleBox = null
#endregion Static Variables

#region Built-in Virtual Methods
func _init() -> void:
	push_error("[JXP Nodes] Static class instantiated.")
#endregion Built-in Virtual Methods

#region Static Methods
## TODO.
static func get_thin_panel_style_box() -> StyleBox:
	if _thin_panel_style_box == null:
		_thin_panel_style_box = StyleBoxEmpty.new()
		_thin_panel_style_box.content_margin_left = 4
		_thin_panel_style_box.content_margin_top = 4
		_thin_panel_style_box.content_margin_right = 4
		_thin_panel_style_box.content_margin_bottom = 4
	return _thin_panel_style_box
#endregion Static Methods
