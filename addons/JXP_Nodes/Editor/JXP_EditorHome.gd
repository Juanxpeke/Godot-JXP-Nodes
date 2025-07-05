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
var _bg_color_cache : Color = Color.BLACK
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _init() -> void:
	var accent_color := EditorInterface.get_editor_theme().get_color("accent_color", "Editor")
	_bg_color_cache = accent_color.lerp(Color.WHITE, 0.33)
	
	var style_box := StyleBoxFlat.new()
	style_box.bg_color = _bg_color_cache
	style_box.content_margin_left = 8
	style_box.content_margin_top = 24
	style_box.content_margin_right = 8
	style_box.content_margin_bottom = 24
	add_theme_stylebox_override("panel", style_box)

func _notification(what : int) -> void:
	if what == NOTIFICATION_THEME_CHANGED:
		var accent_color := EditorInterface.get_editor_theme().get_color("accent_color", "Editor")
		var new_bg_color := accent_color.lerp(Color.WHITE, 0.33)
		
		if _bg_color_cache != new_bg_color:
			_bg_color_cache = new_bg_color
			get_theme_stylebox("panel").bg_color = _bg_color_cache

func _draw() -> void:
	var color := _bg_color_cache.darkened(0.1)
	var offset_x : float = size.x - floor(size.x / 27) * 27
	var offset_y : float = size.y - floor(size.y / 27) * 27
	
	var x := offset_x / 2
	while x < size.x - 3:
		var y := offset_y / 2
		while y < size.y - 3:
			draw_rect(Rect2(x, y, 3, 3), color);
			y += 24
		x += 24
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods
