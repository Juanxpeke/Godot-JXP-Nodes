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
var _title : Label

var _bg_color_cache : Color = Color.BLACK
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _init() -> void:
	_bg_color_cache = EditorInterface.get_editor_theme().get_color("dark_color_3", "Editor")
	
	var style_box := StyleBoxFlat.new()
	style_box.bg_color = _bg_color_cache
	style_box.content_margin_left = 8
	style_box.content_margin_top = 24
	style_box.content_margin_right = 8
	style_box.content_margin_bottom = 24
	add_theme_stylebox_override("panel", style_box)
	
	_title = Label.new()
	_title.text = """
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣶⣶⠶⠶⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⡋⠵⠠⢀⣇⡨⢿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⢀⣤⣴⡶⠿⠿⠛⠋⠀⠀⢀⣠⣤⣥⣴⣟⡓⠶⢦⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⣼⡟⠋⠁⠀⠀⠀⠀⠀⠀⠞⣩⣴⣶⣶⣤⣉⢿⣦⠀⠐⠙⠛⠿⢶⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠸⣿⢀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⠁⠀⠈⢻⣿⡆⢹⣧⠀⠀⠀⠀⠀⠈⠙⠛⠛⠿⠿⠷⢶⣦⣤⣄⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠻⣿⣄⠀⠀⠀⠀⠀⠀⠀⣿⣿⣦⣀⣀⣤⣿⡏⣰⣿⣶⣤⣠⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠙⠻⠿⣶⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠈⢿⣏⠛⢶⣄⡀⠀⠀⠘⢿⣻⠿⠿⠟⢋⣴⡿⠿⣿⣯⣟⣛⣿⣿⣷⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠙⠷⣦⣌⡉⠛⠿⢶⣤⣉⠙⠛⠛⠛⣿⠁⠸⣧⠾⡍⠛⠛⠳⢶⣿⣿⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣷⣄⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⢶⣤⣀⠉⠛⢦⣄⡀⠹⣦⡀⢀⣴⠇⠀⠀⠀⠀⠙⢿⣭⡽⣿⣶⣦⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣯⡟⡟⣷⣦⡀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣦⠀⠉⠛⠶⣤⣀⠉⠙⠛⠻⠯⣥⣀⡀⡀⠀⠀⠀⠀⠈⠙⠿⣯⣭⡿⣿⣷⣄⣀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣿⡿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣷⡄⠀⠀⠀⠈⠉⠓⠒⠒⠂⠀⠀⠈⠉⠓⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⢿⣭⣿⣿⣶⡀⠀⠀⠀⠀⠀⠀⠙⣿⣏⣰⣿⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢤⣀⠀⠈⠙⠻⣿⣿⣦⣄⠀⠀⠀⠀⠀⠈⢻⣿⡃⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢦⡀⠀⠀⠀⠀⠀⠀⠉⠓⢆⡀⠀⠙⠻⣿⣧⣀⠀⠀⠀⠀⠀⠙⣿⡄⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣼⢿⣷⣦⣀⠀⠀⠀⠀⢰⡆⠀⠀⠀⠀⠙⢦⡀⠀⠀⠀⠀⠀⠀⠀⠙⢦⡀⠀⠀⢙⣻⡷⠤⢤⣄⡀⠀⣿⣃⣤⣴⣦⣤⡀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣰⡿⣿⣿⢳⢿⡟⢿⣷⣦⡀⠀⠀⠹⣄⠀⠀⠀⠀⠀⠹⣆⠀⠀⠀⠀⠀⠀⠀⠀⠳⣤⡶⠋⠁⠀⠀⢀⣨⣽⠿⠛⠉⠀⠀⠈⠙⢿⣆
⠀⠀⠀⠀⠀⠀⠀⢀⣠⣴⣿⣿⣛⣷⣯⣼⣮⣛⣧⣛⣿⡻⢷⣦⣀⣀⠹⣦⡀⠀⠀⠀⠀⠘⢧⣄⠀⠀⠀⠀⠀⣠⡾⠋⠀⠀⠀⢠⣼⠿⠋⠁⠀⠀⠀⠀⠀⠀⠀⢸⣿
⠀⢠⣾⢿⠻⣷⣾⣿⣿⣻⣬⣵⣿⣥⣿⣿⣺⣾⣿⣹⢿⣿⣿⣮⣿⢿⣿⣮⣙⣦⠀⠀⠀⠀⠀⠹⣷⠀⠀⠀⢰⡟⠀⠀⠀⠀⢠⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⣀⠄⣸⡇
⠀⠘⢿⣾⣷⠟⠉⢉⣥⡾⠟⣻⣼⠟⠙⣿⡨⠿⣌⠻⠷⠿⠶⣬⣉⣸⡇⣿⡟⠁⠀⠀⠀⠀⠀⢀⣿⠀⠀⢀⣿⠀⠀⠀⠀⢀⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⡴⠃⢀⣿⠀
⠀⠀⠀⠀⢠⣴⢾⢿⣽⣿⠾⠋⠁⠀⠀⠙⢻⡟⠟⣷⣄⠀⠀⠙⠛⠛⣰⡟⠀⠀⠀⠀⠀⠀⠀⣸⣧⣤⡶⢟⡇⠀⠀⠀⠀⠞⠀⠀⠀⠀⠀⠀⠀⠀⣠⡞⠁⠀⣾⡏⠀
⠀⠀⠀⠀⢻⣧⣮⣿⠟⠀⠀⠀⠀⠀⠀⠀⢹⣯⣿⣿⢧⣶⠶⣆⠀⢀⣿⠁⠀⠀⠀⠀⠀⠀⢀⣿⠀⠀⠀⢸⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡾⠋⠀⢀⣾⡟⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⡿⠿⣶⣤⣈⣀⣀⣸⣧⣀⠙⢿⣾⠇⠀⠀⠀⠀⠀⠀⢀⣼⡟⠀⠀⠀⠀⢿⣆⠀⠀⠀⠀⠀⠀⠀⣀⣴⠞⠫⠀⠀⣠⣿⠟⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣷⣤⣤⣤⣉⣉⡉⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⡿⠃⠀⠀⠀⠀⠈⠻⢷⣤⣤⡤⠶⠶⠛⠉⠶⠀⠀⢀⣴⣿⠋⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⠶⣦⣬⠽⠿⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⠟⠁⠀⠀⢰⣾⠿⠿⢟⣩⣤⣄⡀⠉⠉⣰⠋⠀⠀⣠⣿⠟⠁⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣅⢀⣨⣥⣤⣶⣶⣶⠿⠟⠿⠿⣶⣶⣶⣿⠿⠋⠁⠀⠀⠀⠀⠘⠿⠶⣾⣿⢖⡫⠟⢃⣠⠞⠁⢀⣤⣾⠟⠁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣤⣤⣴⠾⢛⡽⠞⢉⣤⣴⠏⠀⣠⣴⡿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣤⣭⡵⠚⣉⣴⣾⡭⠞⢁⣴⡿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⡿⠛⠻⠏⣁⣠⣴⡾⠛⢹⣯⡀⣰⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣧⣤⣴⠿⠛⠉⠁⠀⠀⠈⠛⠛⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
	"""
	_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title.add_theme_constant_override("line_spacing", -4)
	_title.add_theme_color_override("font_color", EditorInterface.get_editor_theme().get_color("accent_color", "Editor"))
	_title.add_theme_font_override("font", EditorInterface.get_editor_theme().get_font("source", "EditorFonts"))
	_title.add_theme_font_size_override("font_size", 12)
	add_child(_title)

func _notification(what : int) -> void:
	if what == NOTIFICATION_THEME_CHANGED:
		var new_bg_color := EditorInterface.get_editor_theme().get_color("dark_color_3", "Editor")
		
		if _bg_color_cache != new_bg_color:
			_bg_color_cache = new_bg_color
			get_theme_stylebox("panel").bg_color = _bg_color_cache # NOTE: this triggers the notification again
		
		_title.add_theme_color_override("font_color", EditorInterface.get_editor_theme().get_color("accent_color", "Editor"))

func _draw() -> void:
	var color := _bg_color_cache.darkened(0.05)
	
	var x := 16
	while x <= size.x - 16:
		var y := 16
		while y <= size.y - 16:
			draw_rect(Rect2(x, y, 3, 3), color);
			y += 24
		x += 24
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods
