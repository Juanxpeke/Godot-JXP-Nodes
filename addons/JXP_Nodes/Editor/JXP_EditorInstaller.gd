@tool
class_name JXP_EditorInstaller extends PanelContainer
## Plugin's modules installer panel.

#region Signals
#endregion Signals

#region Enums
enum _ModuleButtonIndex {
	INSTALL,
	UNINSTALL,
}
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
var _modules_tree : Tree = null
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
	
	_modules_tree = Tree.new()
	_modules_tree.hide_root = true
	_modules_tree.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_modules_tree.button_clicked.connect(_on_modules_tree_button_clicked)
	main_vb.add_child(_modules_tree)
	
	_update_modules_tree()

func _notification(what : int) -> void:
	if what == NOTIFICATION_THEME_CHANGED:
		_update_modules_tree()
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#region Callbacks
func _on_modules_tree_button_clicked(item : TreeItem, column : int, id : int, mouse_button_index : int) -> void:
	match id:
		_ModuleButtonIndex.INSTALL:
			pass
		_ModuleButtonIndex.UNINSTALL:
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

func _update_modules_tree() -> void:
	_modules_tree.clear()
	
	var root := _modules_tree.create_item()
	
	var _category_map : Dictionary
	
	var installed_icon := EditorInterface.get_editor_theme().get_icon("ImportCheck", "EditorIcons")
	var uninstalled_icon := EditorInterface.get_editor_theme().get_icon("ImportFail", "EditorIcons")
	var install_icon := EditorInterface.get_editor_theme().get_icon("AssetLib", "EditorIcons")
	var uninstall_icon := EditorInterface.get_editor_theme().get_icon("Remove", "EditorIcons")
	
	for module in _plugin_modules.get_modules():
		var category_item : TreeItem
		if module.category in _category_map:
			category_item = _category_map[module.category]
		else:
			category_item = _modules_tree.create_item(root)
			category_item.set_text(0, module.category)
			category_item.set_selectable(0, false)
			category_item.set_custom_font(0, EditorInterface.get_editor_theme().get_font("bold", "EditorFonts"))
		
		var module_item := _modules_tree.create_item(category_item)
		module_item.set_text(0, module.name)
		module_item.set_tooltip_text(0, module.description)
		module_item.add_button(0, install_icon, _ModuleButtonIndex.INSTALL, module.installed, "Install")
		module_item.add_button(0, uninstall_icon, _ModuleButtonIndex.UNINSTALL, not module.installed, "Uninstall")
		
		if module.installed:
			module_item.set_icon(0, installed_icon)
		else:
			module_item.set_icon(0, uninstalled_icon)
		
#endregion Private Methods
