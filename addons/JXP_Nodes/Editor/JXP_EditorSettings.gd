@tool
class_name JXP_EditorSettings extends PanelContainer
## Plugin's settings panel.

# Most of the code in this script follows the logic used in the Godot engine itself, specifically,
# in the editor_sectioned_inspector.cpp file.
# TODO: 1. Plugin Editor Filters 2. Plugin Editor Tooltips

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
var _filter : JXP_PropertiesFilter = null
var _section_map : Dictionary
var _selected_section : String
# Nodes
var _search_box : LineEdit = null
var _sections_tree : Tree = null
var _editor_inspector : EditorInspector = null
var _save_timer : Timer = null
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _init() -> void:
	JXP_PluginSettingsManager.initialize()
	
	_filter = JXP_PropertiesFilter.new()
	_filter.set_object(JXP_PluginSettingsManager.get_settings_object())
	
	add_theme_stylebox_override("panel", JXP_PluginStylesManager.get_thin_panel_style_box())
	
	var main_vb = VBoxContainer.new()
	main_vb.alignment = BoxContainer.ALIGNMENT_BEGIN
	main_vb.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(main_vb)
	
	var search_bar := HBoxContainer.new()
	main_vb.add_child(search_bar)
	
	_search_box = LineEdit.new()
	_search_box.placeholder_text = "Filter Settings"
	_search_box.clear_button_enabled = true
	_search_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_search_box.right_icon = EditorInterface.get_editor_theme().get_icon("Search", "EditorIcons")
	search_bar.add_child(_search_box)
	
	var advanced = CheckButton.new()
	advanced.text = "Advanced Settings"
	advanced.toggled.connect(_on_advanced_toggled)
	search_bar.add_child(advanced)
	
	var sectioned_inspector := _create_sectioned_inspector()
	sectioned_inspector.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_vb.add_child(sectioned_inspector)
	
	_save_timer = Timer.new()
	_save_timer.wait_time = 1.5
	_save_timer.one_shot = true
	_save_timer.timeout.connect(ProjectSettings.save)
	add_child(_save_timer)
	
	var use_advanced : bool = EditorInterface.get_editor_settings().get_project_metadata("jxp_plugin_settings", "advanced_mode", false)

	if use_advanced:
		advanced.button_pressed = true
	
	_update_sections_tree()
	
	_editor_inspector.edit(_filter)

func _notification(what : int) -> void:
	if what == NOTIFICATION_THEME_CHANGED:
		_search_box.right_icon = EditorInterface.get_editor_theme().get_icon("Search", "EditorIcons")
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#region Callbacks
func _on_advanced_toggled(toggled_on : bool) -> void:
	_filter.set_restrict_to_basic(not toggled_on)
	EditorInterface.get_editor_settings().set_project_metadata("jxp_plugin_settings", "advanced_mode", toggled_on)

func _on_section_selected() -> void:
	if _sections_tree.get_selected() == null or _sections_tree.get_selected().get_text(0) == "":
		return
	_selected_section = _sections_tree.get_selected().get_metadata(0)
	_filter.set_section(_selected_section, _sections_tree.get_selected().get_first_child() == null)

func _on_editor_inspector_property_edited(property : String) -> void:
	_save_timer.start()
#endregion Callbacks
#region User Interface
func _create_sectioned_inspector() -> HSplitContainer:
	var sectioned_inspector := HSplitContainer.new()
	sectioned_inspector.add_theme_constant_override("autohide", 1) # Fixes the dragger always showing up
	
	var left_vb := VBoxContainer.new()
	left_vb.custom_minimum_size = Vector2(190, 0) * EditorInterface.get_editor_scale()
	sectioned_inspector.add_child(left_vb)
	
	_sections_tree = Tree.new()
	_sections_tree.auto_translate_mode = Node.AUTO_TRANSLATE_MODE_DISABLED
	_sections_tree.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_sections_tree.hide_root = true
	_sections_tree.cell_selected.connect(_on_section_selected)
	left_vb.add_child(_sections_tree, true)
	
	var right_vb := VBoxContainer.new()
	right_vb.custom_minimum_size = Vector2(300, 0) * EditorInterface.get_editor_scale()
	right_vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sectioned_inspector.add_child(right_vb)

	_editor_inspector = EditorInspector.new()
	_editor_inspector.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_editor_inspector.property_edited.connect(_on_editor_inspector_property_edited)
	_editor_inspector.restart_requested.connect(func(): ) # TODO
	right_vb.add_child(_editor_inspector, true)
	
	return sectioned_inspector

func _update_sections_tree() -> void:
	# This method clears and recreates the sections tree, based on the original plugin settings
	# (properties) and the filter applied through the user interface
	# For example, if a property name is "a/b/c/d", this method will create a tree with a tree item
	# with name "a" (first section), and another child item with name "b" (second section)
	_sections_tree.clear()
	_section_map.clear();
	
	var root := _sections_tree.create_item()
	_section_map[""] = root
	
	for property in JXP_PluginSettingsManager.get_settings_object().get_property_list():
		# TODO: Complete discard property logic
		if property.usage & PROPERTY_USAGE_CATEGORY:
			continue
		if not property.usage & PROPERTY_USAGE_EDITOR:
			continue
		
		# If the property name is "a/b/c", we say "a", "b" and "c" are sections
		var sectionarr : PackedStringArray = property.name.split("/")
		var metasection : String
		# Number of sections we may add as tree items, ignoring the property itself
		# Example A: "a/b/c/d/e" will only add "a" and "b", because more than 2 levels is too much
		# Example B: "a/b" will only add "a", because "b" is the property itself
		# NOTE: We didn't apply a global section workaround, properties without "/" will be ignored
		var section_count := mini(2, sectionarr.size() - 1)

		for i in section_count:
			var parent : TreeItem = _section_map[metasection]
			parent.set_custom_font(0, EditorInterface.get_editor_theme().get_font("bold", "EditorFonts"))
			
			if i > 0:
				metasection += "/" + sectionarr[i]
			else:
				metasection = sectionarr[i]
			# If the section is not in map, add it to the tree and map
			if not _section_map.has(metasection):
				var ms := _sections_tree.create_item(parent)
				_section_map[metasection] = ms
				
				var text = _capitalize(sectionarr[i])
				var tooltip = _capitalize(sectionarr[i])
				
				ms.set_text(0, text)
				ms.set_tooltip_text(0, tooltip)
				ms.set_metadata(0, metasection)
				ms.set_selectable(0, false)
			# If this is the last non-property section, make it selectable
			if i == section_count - 1:
				_section_map[metasection].set_selectable(0, true);
	# If there exists a previous selected section (this method was called due to a change in the
	# filters line edit), and it's in this new filtered tree, we go back to it
	if _section_map.has(_selected_section):
		_section_map[_selected_section].select(0)
#endregion User Interface
#region Utility
var _capitalize_string_remaps : Dictionary = {
	"jxp": "JXP",
	"2d": "2D",
	"3d": "3D"
}

var _stop_words : Array[String] = [
	"a",
	"an",
	"and",
	"as",
	"at",
	"by",
	"for",
	"in",
	"not",
	"of",
	"on",
	"or",
	"over",
	"per",
	"the",
	"then",
	"to",
]

func _capitalize(text : String) -> String:
	var parts : PackedStringArray = text.split("_", false);
	for i in parts.size():
		# Only capitalize a stop word when its at the beginning or at the end
		if i > 0 and i < parts.size() - 1 and _stop_words.has(parts[i]):
			continue;
		
		if _capitalize_string_remaps.has(parts[i]):
			parts.set(i, _capitalize_string_remaps[parts[i]])
		else:
			parts.set(i, parts[i].capitalize())
	
	var capitalized := String(" ").join(parts);
	
	return capitalized
#endregion Utility
#endregion Private Methods
