@tool
class_name JXP_PluginInstallationManager extends Object
## Static class that stores all the plugin installation information.
##
## [b]Note:[/b] This needs to be a tool script, otherwise the static variables won't be initialized.

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Static Variables
static var _modules : Dictionary = {
	"outlines": {
		"name": "Outlines",
		"category": "Rendering 3D",
		"description": "Outlines for 3D elements and related scripts",
		"plugin_relative_path": "Graphics/Outlines/",
		"installed": false,
	},
	"hittables": {
		"name": "Hittables",
		"category": "Physics 3D",
		"description": "Hittables",
		"plugin_relative_path": "Physics/Hittables/",
		"installed": false,
	},
	"methods_list": {
		"name": "Methods List",
		"category": "Debug",
		"description": "A new inspector tab that allows the call of methods of any object in run-time",
		"plugin_relative_path": "Debug/MethodsList/",
		"installed": false,
	},
}
#endregion Static Variables

#region Built-in Virtual Methods
func _init() -> void:
	push_error("[JXP Nodes] Static class instantiated.")
#endregion Built-in Virtual Methods

#region Static Methods
## TODO.
static func get_current_version() -> ParsedVersion:
	var plugin_cfg := ConfigFile.new()
	plugin_cfg.load("res://addons/JXP_Nodes/plugin.cfg")
	var version : String = plugin_cfg.get_value("plugin", "version", "unknown version")
	return ParsedVersion.from_string(version)
## TODO.
static func get_modules() -> Array:
	return _modules.values()
## TODO.
static func check_installed_state() -> void:
	for module_name in _modules:
		var module : Dictionary = _modules[module_name]
		var module_path : String = module.plugin_relative_path
		
		var dir := DirAccess.open("res://addons/JXP_Nodes/" + module_path)
		if dir == null:
			module.installed = false
		else:
			module.installed = true
		_modules[module_name] = module
#endregion Static Methods

#region Inner Classes
class ParsedVersion:
	# TODO: Prerelease and metadata variables and logic
	var major : int = 0
	var minor : int = 0
	var patch : int = 0
	var valid : bool = false
	
	func _to_string() -> String:
		if not valid:
			return ""
		return "%d.%d.%d" % [major, minor, patch]
	
	func is_equal(parsed_version : ParsedVersion) -> bool:
		if major != parsed_version.major:
			return false
		if minor != parsed_version.minor:
			return false
		if patch != parsed_version.patch:
			return false
		return true
	
	func is_greater_than(parsed_version : ParsedVersion) -> bool:
		if major > parsed_version.major:
			return true
		if minor > parsed_version.minor:
			return true
		if patch > parsed_version.patch:
			return true
		return false
	
	static func from_string(version : String) -> ParsedVersion:
		var parsed_version := ParsedVersion.new()
		
		version = version.strip_edges().trim_prefix('v')
		version = version.substr(0, version.find('('))
		version = version.to_lower()

		var regex := RegEx.create_from_string(r"^(?P<major>0|[1-9]\d*)\.(?P<minor>0|[1-9]\d*)\.(?P<patch>0|[1-9]\d*)(?:-(?P<prerelease>(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+(?P<buildmetadata>[0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$")
		var result : RegExMatch = regex.search(version)
		if result == null:
			parsed_version.valid = false
			return parsed_version
		else:
			parsed_version.valid = true
		
		if result.get_string("major") != "":
			parsed_version.major = int(result.get_string("major"))
		if result.get_string("minor") != "":
			parsed_version.minor = int(result.get_string("minor"))
		if result.get_string("patch") != "":
			parsed_version.patch = int(result.get_string("patch"))
		
		return parsed_version
#endregion Inner Classes
