class_name JXP_PluginModules extends Object
## Object that stores all the plugin modules information.
##
## This object is designed to be passed to a [EditorInspector].
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
		"installed": true,
	},
	"hittables": {
		"name": "Hittables",
		"category": "Physics 3D",
		"description": "Hittables",
		"installed": false,
	},
	"methods_list": {
		"name": "Methods List",
		"category": "Debug",
		"description": "A new inspector tab that allows the call of methods of any object in run-time",
		"installed": false,
	},
}
#endregion Private Variables

#region Built-in Virtual Methods
func _init() -> void:
	pass
#endregion Built-in Virtual Methods

#region Public Methods
func get_modules() -> Array:
	return _modules.values()
#endregion Public Methods

#region Private Methods
func _update_project_modules() -> void:
	for module_name : StringName in _modules.keys():
		var module : Dictionary = _modules[module_name]
		
		if EditorInterface.get_editor_settings().get_project_metadata("jxp_plugin_settings", module_name, null) == null:
			EditorInterface.get_editor_settings().set_project_metadata("jxp_plugin_settings", module_name, _modules[module_name].cache)
		else:
			pass
#endregion Private Methods
