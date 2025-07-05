@tool
class_name JXP_EditorHome extends PanelContainer
## Plugin's desktop panel.

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
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _init() -> void:
	var style_box : StyleBoxFlat = EditorInterface.get_editor_theme().get_stylebox("panel", "Tree").duplicate()
	style_box.bg_color = Color.BLACK.lerp(style_box.bg_color, 0.75)
	style_box.content_margin_left = 8
	style_box.content_margin_top = 24
	style_box.content_margin_right = 8
	style_box.content_margin_bottom = 24
	add_theme_stylebox_override("panel", style_box)

func _draw() -> void:
	pass
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods
