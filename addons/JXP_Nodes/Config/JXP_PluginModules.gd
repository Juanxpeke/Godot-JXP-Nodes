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
	"godot_version": {
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "4.4, 4.5, 4.6, 5.1",
		"usage": PROPERTY_USAGE_EDITOR,
		"installed": 0,
		"install": 0,
	},
	"rendering_3d/outlines": {
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
		"hint_string": "",
		"usage": PROPERTY_USAGE_EDITOR,
		"installed": false,
		"install": false,
	},
	"physics_3d/hittables": {
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
		"hint_string": "",
		"usage": PROPERTY_USAGE_EDITOR,
		"installed": false,
		"install": false,
	},
	"debug/methods_list": {
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
		"hint_string": "",
		"usage": PROPERTY_USAGE_EDITOR,
		"installed": false,
		"install": false,
	},
}
#endregion Private Variables

#region Built-in Virtual Methods
func _init() -> void:
	pass
# NOTE: Only necessary for the plugin modules installer interface
func _get_property_list() -> Array:
	var properties := []
	for module_name in _modules.keys():
		var module : Dictionary = _modules[module_name] 
		properties.append({
			"name": module_name,
			"type": module.type,
			"hint": module.hint,
			"hint_string": module.hint_string,
			"usage": module.usage
		})
	return properties
# NOTE: Only necessary for the plugin modules installer interface
func _get(property : StringName) -> Variant:
	if _modules.has(property):
		return _modules[property].cache
	return null
# NOTE: Only necessary for the plugin modules installer interface
func _set(property : StringName, value : Variant) -> bool:
	if _modules.has(property):
		_modules[property].cache = value
		return true
	return false
# NOTE: Only necessary for the plugin modules installer interface
func _property_can_revert(property : StringName) -> bool:
	return false
# NOTE: Only necessary for the plugin modules installer interface
func _property_get_revert(property : StringName) -> Variant:
	return null
#endregion Built-in Virtual Methods

#region Public Methods
## TODO.
func save_cached_values() -> void:
	for module_name : StringName in _modules.keys():
		var module : Dictionary = _modules[module_name]
		EditorInterface.get_editor_settings().set_project_metadata("jxp_plugin_settings", module_name, _modules[module_name].cache)
#endregion Public Methods

#region Private Methods
func _remove_deprecated_project_settings() -> void:
	for setting in ProjectSettings.get_property_list():
#		if setting.name.contains(SETTING_PREFIX) and not setting.name.replace(SETTING_PREFIX, "") in _settings:
#			ProjectSettings.set_setting(setting.name, null)
		push_warning("[JXP Nodes] Removed deprecated setting %s found in project settings" % [setting.name])

func _update_project_modules() -> void:
	for module_name : StringName in _modules.keys():
		var module : Dictionary = _modules[module_name]
		
		if EditorInterface.get_editor_settings().get_project_metadata("jxp_plugin_settings", module_name, null) == null:
			EditorInterface.get_editor_settings().set_project_metadata("jxp_plugin_settings", module_name, _modules[module_name].cache)
		else:
			pass
#endregion Private Methods
