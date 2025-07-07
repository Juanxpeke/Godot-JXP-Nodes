class_name JXP_PluginModules extends Object
## Object that stores all the plugin modules information.
#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Public Variables
#endregion Public Variables

#region Private Variables
var _modules := {
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
#endregion Private Variables

#region Built-in Virtual Methods
func _init() -> void:
	check_installed_state()
#endregion Built-in Virtual Methods

#region Public Methods
## TODO.
func get_modules() -> Array:
	return _modules.values()
## TODO.
func check_installed_state() -> void:
	for module_name in _modules:
		var module : Dictionary = _modules[module_name]
		var module_path : String = module.plugin_relative_path
		
		var dir := DirAccess.open("res://addons/JXP_Nodes/" + module_path)
		if dir == null:
			module.installed = false
		else:
			module.installed = true
		_modules[module_name] = module
#endregion Public Methods

#region Private Methods
#endregion Private Methods
