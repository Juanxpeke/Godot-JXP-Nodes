class_name JXP_PropertiesFilter extends Object
## Docstring

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
var _object : Object = null
var _section : String = ""
var _allow_sub : bool = false
# Use this while Godot maintains EditorInspector.set_restrict_to_basic_settings private
var _restrict_to_basic : bool = true
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _set(property : StringName, value : Variant) -> bool:
	if _object == null:
		return false
	return _object._set(_get_property_original_name(property), value)

func _get(property : StringName) -> Variant:
	if _object == null:
		return null
	return _object._get(_get_property_original_name(property))

func _get_property_list() -> Array:
	if not _object:
		return []
	
	var properties := []
	
	for object_property in _object._get_property_list():
		if object_property.name == "resource_path" or object_property.name == "resource_name" or object_property.name == "resource_local_to_scene" or object_property.name.begins_with("script/") or object_property.name.begins_with("_global_script"):
			continue
		
		if object_property.name.begins_with(_section + "/"):
			object_property.name = object_property.name.replace(_section + "/", "") # WARNING: It should be replace_first instead of replace
			if not _allow_sub and object_property.name.contains("/"):
				continue
			if _restrict_to_basic and not object_property.usage & PROPERTY_USAGE_EDITOR_BASIC_SETTING:
				continue
			properties.push_back(object_property)
	return properties

func _property_can_revert(property : StringName) -> bool:
	if _object == null:
		return false
	return _object._property_can_revert(_get_property_original_name(property))

func _property_get_revert(property : StringName) -> Variant:
	if _object == null:
		return null
	return _object._property_get_revert(_get_property_original_name(property))
#endregion Built-in Virtual Methods

#region Public Methods
## TODO.
func set_section(section : String, allow_sub : bool) -> void:
	_section = section
	_allow_sub = allow_sub
	notify_property_list_changed()
## TODO.
func set_object(object : Object) -> void:
	_object = object
	notify_property_list_changed()
## TODO.
func set_restrict_to_basic(value : bool) -> void:
	_restrict_to_basic = value
	notify_property_list_changed()
#endregion Public Methods

#region Private Methods
func _get_property_original_name(property : StringName) -> String:
	if not _section.is_empty():
		return _section + "/" + property
	return property
#endregion Private Methods
