@tool
class_name JXP_PluginSettingsManager extends Object
## Static class that stores all the plugin settings information.
##
## This object is designed to be passed to a [EditorInspector]. It is also synchronized with the 
## global project settings. See [ProjectSettings].
## [b]Note:[/b] This needs to be a tool script, otherwise the static variables won't be initialized.
#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
const _SETTING_PREFIX := "jxp_nodes/"
#endregion Constants

#region Static Variables
static var _settings_object : SettingsObject = null

static var _settings := {
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
#endregion Static Variables

#region Built-in Virtual Methods
func _init() -> void:
	push_error("[JXP Nodes] Static class instantiated.")
#endregion Built-in Virtual Methods

#region Static Methods
## TODO.
static func initialize() -> void:
	_remove_deprecated_project_settings()
	_update_project_settings()

static func _remove_deprecated_project_settings() -> void:
	for setting in ProjectSettings.get_property_list():
		if setting.name.contains(_SETTING_PREFIX) and not setting.name.replace(_SETTING_PREFIX, "") in _settings:
			ProjectSettings.set_setting(setting.name, null)
			push_warning("[JXP Nodes] Removed deprecated setting %s found in project settings." % [setting.name])

static func _update_project_settings() -> void:
	# NOTE: If property value is equal to its initial value, it is saved in project settings, but
	#       is not written in the project.godot file
	for raw_setting_name : StringName in _settings.keys():
		var setting_name := _SETTING_PREFIX + raw_setting_name
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
## TODO.
static func get_settings_object() -> SettingsObject:
	if _settings_object == null:
		_settings_object = SettingsObject.new()
	return _settings_object
#endregion Static Methods

#region Inner Classes
# NOTE: Only necessary for the plugin settings interface
class SettingsObject extends Object:
	func _get_property_list() -> Array:
		var properties := []
		for raw_setting_name in JXP_PluginSettingsManager._settings.keys():
			var setting : Dictionary = JXP_PluginSettingsManager._settings[raw_setting_name] 
			properties.append({
				"name": raw_setting_name,
				"type": setting.type,
				"hint": setting.hint,
				"hint_string": setting.hint_string,
				"usage": setting.usage
			})
		return properties
	
	func _get(property : StringName) -> Variant:
		if JXP_PluginSettingsManager._settings.has(property):
			var setting_name = _SETTING_PREFIX + property
			return ProjectSettings.get_setting(setting_name, JXP_PluginSettingsManager._settings[property].default)
		return null
	
	func _set(property : StringName, value : Variant) -> bool:
		if JXP_PluginSettingsManager._settings.has(property):
			var setting_name = _SETTING_PREFIX + property
			ProjectSettings.set_setting(setting_name, value)
			return true
		return false
	
	func _property_can_revert(property : StringName) -> bool:
		return JXP_PluginSettingsManager._settings.has(property)
	
	func _property_get_revert(property : StringName) -> Variant:
		if JXP_PluginSettingsManager._settings.has(property):
			return JXP_PluginSettingsManager._settings[property].default
		return null
#endregion Inner Classes
