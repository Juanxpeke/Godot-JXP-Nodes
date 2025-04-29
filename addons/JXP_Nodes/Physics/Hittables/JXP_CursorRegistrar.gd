class_name JXP_CursorRegistrar extends JXP_HitRegistrar
## Docstring
##
## [b]Crashes without:[/b] [JXP_HitRegistrar].

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
## TODO
@export var camera : Camera3D = null
## TODO
@export var ray_length : float = 128.0
## TODO
@export_flags_3d_physics var ray_collision_mask : int = 0
#endregion Exports Variables

#region Public Variables
## TODO
var hittables_collision_dict : Dictionary = {}
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _init() -> void:
	add_to_group("JXP_CursorRegistrar")

func _enter_tree() -> void:
	super()
	assert(camera, "You must select a Camera3D node that defines the ray origin and direction.")
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func _update_last_collider() -> void:
	var space_state = camera.get_world_3d().direct_space_state
	
	var mouse_cursor_position := get_viewport().get_mouse_position()
	var camera_ray_start := camera.project_ray_origin(mouse_cursor_position)
	var camera_ray_end := camera_ray_start + camera.project_ray_normal(mouse_cursor_position) * ray_length
	
	var hittables_query := PhysicsRayQueryParameters3D.create(camera_ray_start, camera_ray_end)
	hittables_query.collide_with_bodies = true
	hittables_query.collide_with_areas = true
	hittables_query.collision_mask = ray_collision_mask
	
	hittables_collision_dict = space_state.intersect_ray(hittables_query)
	
	if hittables_collision_dict.is_empty():
		last_collider = null
	else:
		last_collider = hittables_collision_dict.collider
#endregion Private Methods
