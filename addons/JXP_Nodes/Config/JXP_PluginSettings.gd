class_name JXP_PluginSettings extends Object
## Object that stores all the plugin settings.
##
## This object is designed to be passed to a [EditorInspector]. It is also synchronized with the 
## global project settings. See [ProjectSettings].
#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
## Prefix applied to every setting's name.
const SETTING_PREFIX := "jxp_nodes/"
#endregion Constants

#region Public Variables
#endregion Public Variables

#region Private Variables
var _settings := {
	"installation/godot_version": {
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_NONE,
		"hint_string": "",
		"usage": PROPERTY_USAGE_INTERNAL,
		"default": "Holaa"
	},
	"installation/physics/hittables":{
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
		"hint_string": "",
		"usage": PROPERTY_USAGE_INTERNAL,
		"default": true
	},
	"physics_3d/hittables/default_interaction_name": {
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "0,100,1",
		"usage": PROPERTY_USAGE_EDITOR,
		"default": 99
	},
	"physics_3d/hittables/outline_shader": {
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "0,100,1",
		"usage": PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_EDITOR_BASIC_SETTING,
		"default": 99
	}
}
#endregion Private Variables

#region Built-in Virtual Methods
func _init() -> void:
	_remove_deprecated_project_settings()
	_update_project_settings()
# NOTE: Only necessary for the plugin settings interface
func _get_property_list() -> Array:
	var properties := []
	for raw_setting_name in _settings.keys():
		var setting : Dictionary = _settings[raw_setting_name] 
		properties.append({
			"name": raw_setting_name,
			"type": setting.type,
			"hint": setting.hint,
			"hint_string": setting.hint_string,
			"usage": setting.usage
		})
	return properties
# NOTE: Only necessary for the plugin settings interface
func _get(property : StringName) -> Variant:
	if _settings.has(property):
		var setting_name = SETTING_PREFIX + property
		return ProjectSettings.get_setting(setting_name, _settings[property].default)
	return null
# NOTE: Only necessary for the plugin settings interface
func _set(property : StringName, value : Variant) -> bool:
	if _settings.has(property):
		var setting_name = SETTING_PREFIX + property
		ProjectSettings.set_setting(setting_name, value)
		return true
	return false
# NOTE: Only necessary for the plugin settings interface
func _property_can_revert(property : StringName) -> bool:
	return _settings.has(property)
# NOTE: Only necessary for the plugin settings interface
func _property_get_revert(property : StringName) -> Variant:
	if _settings.has(property):
		return _settings[property].default
	return null
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func _remove_deprecated_project_settings() -> void:
	for setting in ProjectSettings.get_property_list():
		if setting.name.contains(SETTING_PREFIX) and not setting.name.replace(SETTING_PREFIX, "") in _settings:
			ProjectSettings.set_setting(setting.name, null)
			push_warning("[JXP Nodes] Removed deprecated setting %s found in project settings" % [setting.name])

func _update_project_settings() -> void:
	# NOTE: If property value is equal to its initial value, it is saved in project settings, but
	#       is not written in the project.godot file
	for raw_setting_name : StringName in _settings.keys():
		var setting_name := SETTING_PREFIX + raw_setting_name
		var setting : Dictionary = _settings[raw_setting_name]
		
		if not ProjectSettings.has_setting(setting_name):
			ProjectSettings.set_setting(setting_name, setting.default)
		
		ProjectSettings.set_as_basic(setting_name, setting.usage & PROPERTY_USAGE_EDITOR_BASIC_SETTING)
		ProjectSettings.set_as_internal(setting_name, setting.usage & PROPERTY_USAGE_INTERNAL)
		ProjectSettings.set_initial_value(setting_name, setting.default)
		ProjectSettings.set_restart_if_changed(setting_name, setting.usage & PROPERTY_USAGE_RESTART_IF_CHANGED)
		
		ProjectSettings.add_property_info({
			"name": setting_name,
			"type": setting.type,
			"hint": setting.hint,
			"hint_string": setting.hint_string,
		})
	
	ProjectSettings.save()
#endregion Private Methods
