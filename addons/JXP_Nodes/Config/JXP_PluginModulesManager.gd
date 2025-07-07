@tool
class_name JXP_PluginModulesManager extends Object
## Static class that stores all the plugin modules information.
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
