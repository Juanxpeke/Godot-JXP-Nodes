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
const _PLUGIN_RELEASES_URL := "https://api.github.com/repos/Juanxpeke/Godot-JXP-Nodes/releases"
const _TEMP_FILE_NAME := "user://jxp_nodes_temp.zip"
#endregion Constants

#region Exports Variables
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
# Data
var _current_version : JXP_PluginInstallationManager.ParsedVersion = null
var _latest_version : JXP_PluginInstallationManager.ParsedVersion = null
var _latest_version_url : String # NOTE: We won't use https://api.github.com/repos/Juanxpeke/Godot-JXP-Nodes/releases/latest
# Nodes
var _releases_request : HTTPRequest = null
var _current_version_request : HTTPRequest = null

var _plugin_version : Label = null
var _plugin_update_button : Button = null
var _refresh_button : Button = null
var _refresh_timer : Timer = null

var _modules_tree : Tree = null
var _selected_module_container : PanelContainer = null
var _selected_module_title : Label = null
var _selected_module_description : Label = null
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _init() -> void:
	JXP_PluginInstallationManager.check_installed_state()
	
	_current_version = JXP_PluginInstallationManager.get_current_version()
	_latest_version = _current_version
	
	if not _current_version.valid:
		pass # TODO: UI and UX
	
	add_theme_stylebox_override("panel", JXP_PluginStylesManager.get_thin_panel_style_box())
	
	_releases_request = HTTPRequest.new()
	_releases_request.request_completed.connect(_on_releases_request_completed)
	add_child(_releases_request)
	
	_current_version_request = HTTPRequest.new()
	_current_version_request.request_completed.connect(_on_current_version_request_completed)
	add_child(_current_version_request)
	
	var main_vb = VBoxContainer.new()
	main_vb.alignment = BoxContainer.ALIGNMENT_BEGIN
	main_vb.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(main_vb)
	
	var top_hb := HBoxContainer.new()
	main_vb.add_child(top_hb)
	
	_plugin_version = Label.new()
	_plugin_version.text = "Requesting plugin version..."
	_plugin_version.clip_text = true
	_plugin_version.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_hb.add_child(_plugin_version)
	
	_plugin_update_button = Button.new()
	_plugin_update_button.text = "Update Plugin"
	_plugin_update_button.disabled = true
	_plugin_update_button.tooltip_text = "Update installed modules to the latest version."
	top_hb.add_child(_plugin_update_button)
	
	_refresh_button = Button.new()
	_refresh_button.text = "Refresh"
	_refresh_button.tooltip_text = "Request releases data from Github."
	_refresh_button.pressed.connect(_on_refresh_button_pressed)
	top_hb.add_child(_refresh_button)
	
	_refresh_timer = Timer.new()
	_refresh_timer.wait_time = 1.0
	_refresh_timer.one_shot = true
	_refresh_timer.timeout.connect(_refresh_button.set_disabled.bind(false))
	_refresh_button.add_child(_refresh_timer)
	
	var bottom_hb := HBoxContainer.new()
	bottom_hb.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_vb.add_child(bottom_hb)
	
	_modules_tree = Tree.new()
	_modules_tree.hide_root = true
	_modules_tree.custom_minimum_size = Vector2(300, 0) * EditorInterface.get_editor_scale()
	_modules_tree.button_clicked.connect(_on_modules_tree_button_clicked)
	bottom_hb.add_child(_modules_tree)
	
	_selected_module_container = PanelContainer.new()
	_selected_module_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_selected_module_container.add_theme_stylebox_override("panel", EditorInterface.get_editor_theme().get_stylebox("panel", "Tree"))
	bottom_hb.add_child(_selected_module_container)
	
	var selected_module_vb := VBoxContainer.new()
	_selected_module_container.add_child(selected_module_vb)
	
	_selected_module_title = Label.new()
	_selected_module_title.text = "Module"
	_selected_module_title.add_theme_font_override("font", EditorInterface.get_editor_theme().get_font("title", "EditorFonts"))
	selected_module_vb.add_child(_selected_module_title)
	
	_update_top_layout()
	_update_modules_tree()

func _ready() -> void:
	# HTTP nodes have to be inside tree to make requests. If it's disconnected, it is 99% good to go
	if _releases_request.get_http_client_status() == HTTPClient.STATUS_DISCONNECTED:
		_refresh_button.disabled = true
		_releases_request.request(_PLUGIN_RELEASES_URL)
		_refresh_timer.start()

func _exit_tree() -> void:
	DirAccess.remove_absolute(_TEMP_FILE_NAME)

func _notification(what : int) -> void:
	if what == NOTIFICATION_THEME_CHANGED:
		_update_top_layout()
		_update_modules_tree()
		_selected_module_container.add_theme_stylebox_override("panel", EditorInterface.get_editor_theme().get_stylebox("panel", "Tree"))
#endregion Built-in Virtual Methods

#region Private Methods
#region Callbacks
func _on_releases_request_completed(result : int, response_code : int, headers : PackedStringArray, body : PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		push_warning("[JXP Nodes] Failed to fetch releases data.")
	
	# The response should be an array of dictionaries (each for the information of each release)
	var response : Variant = JSON.parse_string(body.get_string_from_utf8())
	if typeof(response) == TYPE_DICTIONARY and response.has("message") and response["message"].contains("rate limit"):
		push_warning("GitHub API rate limit exceeded; you'll have to wait at most 60 minutes.")
		return
	elif typeof(response) != TYPE_ARRAY:
		push_warning("Unknown response while trying to fetch releases data.")
		return
	
	var releases : Array = response
	
	for release : Dictionary in releases:
		var release_version := JXP_PluginInstallationManager.ParsedVersion.from_string(release.tag_name)
		if release_version.is_equal(_current_version):
			_current_version_request.request(release.zipball_url)
		elif release_version.is_greater_than(_latest_version):
			_latest_version = release_version
			_latest_version_url = release.zipball_url
	
	# UI and UX stuff
	_update_top_layout()

func _on_current_version_request_completed(result : int, response_code : int, headers : PackedStringArray, body : PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		push_warning("[JXP Nodes] Failed to fetch current version data.")
	
	# Save the downloaded ZIP as a temporal file, this ZIP file will be available as long
	# as the editor is opened
	var zip_file := FileAccess.open(_TEMP_FILE_NAME, FileAccess.WRITE)
	zip_file.store_buffer(body)
	zip_file.close()

func _on_refresh_button_pressed() -> void:
	if _releases_request.get_http_client_status() == HTTPClient.STATUS_DISCONNECTED:
		_refresh_button.disabled = true
		_releases_request.request(_PLUGIN_RELEASES_URL)
		_refresh_timer.start()

func _on_modules_tree_button_clicked(item : TreeItem, column : int, id : int, mouse_button_index : int) -> void:
	var module : Dictionary = item.get_metadata(0)
	match id:
		_ModuleButtonIndex.INSTALL:
			_install_module(module.plugin_relative_path)
		_ModuleButtonIndex.UNINSTALL:
			_uninstall_module(module.plugin_relative_path)
#endregion Callbacks
func _install_module(module_path : String) -> void:
	var zip_reader := ZIPReader.new()
	zip_reader.open(_TEMP_FILE_NAME)
	# TODO: There was one time in which the ZIP did not exist so this gave an error
	var release_files_paths : PackedStringArray = zip_reader.get_files()
	var release_folder_name : String = release_files_paths[0]
	var release_plugin_path: String = release_folder_name.path_join('addons/JXP_Nodes/')
	
	for release_file_path in release_files_paths:
		if not release_plugin_path + module_path in release_file_path:
			continue

		var relative_file_path: String = release_file_path.replace(release_plugin_path, "")
		if release_file_path.ends_with("/"):
			DirAccess.make_dir_recursive_absolute("res://addons/JXP_Nodes/".path_join(relative_file_path))
		else:
			var file: FileAccess = FileAccess.open("res://addons/JXP_Nodes/".path_join(relative_file_path), FileAccess.WRITE)
			file.store_buffer(zip_reader.read_file(release_file_path))
	
	zip_reader.close()
	
	JXP_PluginInstallationManager.check_installed_state()
	
	_update_modules_tree()

func _uninstall_module(module_path : String) -> void:
	var error := OS.move_to_trash(ProjectSettings.globalize_path("res://addons/JXP_Nodes/" + module_path))
	
	JXP_PluginInstallationManager.check_installed_state()
	
	# TODO: UI and UX
	_update_modules_tree()

func _update_top_layout() -> void:
	_plugin_version.text = "Version " + str(_current_version)
	_plugin_update_button.disabled = not _latest_version.is_greater_than(_current_version)

func _update_modules_tree() -> void:
	_modules_tree.clear()
	
	var root := _modules_tree.create_item()
	
	var _category_map : Dictionary
	
	var installed_icon := EditorInterface.get_editor_theme().get_icon("ImportCheck", "EditorIcons")
	var uninstalled_icon := EditorInterface.get_editor_theme().get_icon("ImportFail", "EditorIcons")
	var reinstall_icon := EditorInterface.get_editor_theme().get_icon("Reload", "EditorIcons")
	var install_icon := EditorInterface.get_editor_theme().get_icon("AssetLib", "EditorIcons")
	var uninstall_icon := EditorInterface.get_editor_theme().get_icon("Remove", "EditorIcons")
	
	for module in JXP_PluginInstallationManager.get_modules():
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
		module_item.set_metadata(0, module)
		
		if module.installed:
			module_item.set_icon(0, installed_icon)
			module_item.add_button(0, reinstall_icon, _ModuleButtonIndex.INSTALL, false, "Reinstall")
			module_item.add_button(0, uninstall_icon, _ModuleButtonIndex.UNINSTALL, false, "Uninstall")
		else:
			module_item.set_icon(0, uninstalled_icon)
			module_item.add_button(0, install_icon, _ModuleButtonIndex.INSTALL, false, "Install")
			module_item.add_button(0, uninstall_icon, _ModuleButtonIndex.UNINSTALL, true, "Uninstall")
#endregion Private Methods
