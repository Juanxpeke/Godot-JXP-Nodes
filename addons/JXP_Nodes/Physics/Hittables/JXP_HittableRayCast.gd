class_name JXP_HittableRayCast extends RayCast3D
## TODO
##
## [b]Strong dependencies:[/b] [JXP_HittableComponent].

#region Signals
## TODO
signal hit_registered(hittable_component : JXP_HittableComponent)
## TODO
signal hit_unregistered
## TODO
signal pick_registered
## TODO
signal pick_unregistered
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
## TODO
@export var hand_node : Node3D
## The name of the variable explains everything.
@export var use_hand_node_as_pick_target_position : bool = false

@export_group("Actions")
## TODO
@export var interact_action : String = "interact"
## TODO
@export var pick_action : String = "pick"
#endregion Exports Variables

#region Public Variables
## TODO. Do not modify this variable.
var last_collider : CollisionObject3D = null
## TODO. Do not modify this variable.
var last_hittable_component : JXP_HittableComponent = null:
	set(new_last_hittable_component):
		last_hittable_component = new_last_hittable_component
		if last_hittable_component:
			hit_registered.emit(last_hittable_component)
		else:
			hit_unregistered.emit()
## TODO
var picking : bool:
	set(new_picking):
		picking = new_picking
		if picking:
			pick_registered.emit()
		else:
			pick_unregistered.emit()
#endregion Public Variables

#region Private Variables
var _pick_target_position : Vector3
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _physics_process(_delta : float) -> void:
	last_collider = get_collider()
	
	_update_pick_target_position()
	
	if not picking:
		_update_last_hittable_component()
	else:
		if not is_instance_valid(last_hittable_component):
			picking = false
			return # WARNING: There should be a last hittable component
		
		last_hittable_component.register_picking_process(_delta, _pick_target_position, _unpick_last_hittable_component)

func _input(event : InputEvent) -> void:
	if not is_instance_valid(last_hittable_component):
		return
	
	if InputMap.has_action(pick_action) and InputMap.has_action(interact_action):
		pass
	else:
		return
	
	if last_hittable_component.interactable and event.is_action_pressed(interact_action):
		last_hittable_component.register_interaction()
	
	if not picking and last_hittable_component.pickable and event.is_action_pressed(pick_action):
		assert(not last_hittable_component.being_picked) # NOTE: At the moment, some code assumes a
														 #       hittable component can be picked by
														 #       only one hittable ray cast
		_pick_last_hittable_component()
	
	# Safer in case pickable is set to false but still being picked
	if last_hittable_component.being_picked and event.is_action_released(pick_action):
		_unpick_last_hittable_component()

#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func _update_last_hittable_component() -> void:
	var hittable_component := _get_hittable_component(last_collider)
	
	if hittable_component != last_hittable_component:
		# Make sure last_hittable_component is not null nor being freed before unregistering hit
		if is_instance_valid(last_hittable_component):
			last_hittable_component.unregister_hit()
		
		last_hittable_component = hittable_component
		
		if is_instance_valid(last_hittable_component):
			last_hittable_component.register_hit()

func _pick_last_hittable_component() -> void:
	picking = true
	last_hittable_component.register_pick(_pick_target_position)

func _unpick_last_hittable_component() -> void:
	picking = false
	last_hittable_component.register_unpick()

func _update_pick_target_position() -> void:
	var raw_pick_target_position : Vector3
	
	if use_hand_node_as_pick_target_position:
		assert(hand_node)
		raw_pick_target_position = hand_node.global_transform.origin
	else:
		raw_pick_target_position = global_transform.origin + global_transform.basis * target_position
	
	if picking:
		_pick_target_position = raw_pick_target_position ## TODO: WTF
	else:
		_pick_target_position = raw_pick_target_position

func _get_hittable_component(node : Node3D) -> JXP_HittableComponent:
	if node != null and node.has_meta("JXP_HittableComponentPath"):
		var component_path = node.get_meta("JXP_HittableComponentPath", null)
		return node.get_node(component_path)
	else:
		return null
#endregion Private Methods
