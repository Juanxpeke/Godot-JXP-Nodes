class_name JXP_HitRegistrar extends Node
## TODO
##
## [b]Crashes without:[/b] [JXP_HittableComponent].

#region Signals
## TODO
signal stopped_hitting
## Emitted when this node hits an object that has a [JXP_HittableComponent]. Use this signal
## for global logic, such as updating the HUD with information about the current object being
## hit. For per-object logic, use [signal JXP_HittableComponent.hit] instead.
signal hit_registered(hittable_component : JXP_HittableComponent)
## Emitted when this node unhits an object that has a [JXP_HittableComponent]. Use this signal
## for global logic. For per-object logic, use [signal JXP_HittableComponent.unhit] instead.
signal unhit_registered
## TODO
signal event_press_registered(hittable_component : JXP_HittableComponent, event : InputEvent)
## TODO
signal event_released_registered(hittable_component : JXP_HittableComponent, event : InputEvent)
## TODO
signal interaction_registered
## TODO
signal pick_registered
## TODO
signal unpick_registered
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
@export_group("Actions")
## Godot action that has to be pressed to interact when an object is being hit. This can be used
## for actions like turning on and off a TV, eating a chocolate bar, or displaying a tooltip. See 
## [signal JXP_HittableComponent.interacted].
@export var interact_action : String = "interact"
## Godot action that has to be hold to pick an object 
@export var pick_action : String = "pick"
#endregion Exports Variables

#region Public Variables
## TODO. Do not modify this variable.
var last_collider : CollisionObject3D = null
## TODO. Do not modify this variable.
var last_hittable_component : JXP_HittableComponent = null:
	set(new_last_hittable_component):
		if last_hittable_component:
			unhit_registered.emit(last_hittable_component)
		
		last_hittable_component = new_last_hittable_component
		
		if last_hittable_component:
			hit_registered.emit(last_hittable_component)
		else:
			stopped_hitting.emit()
## TODO. Do not modify this variable.
var picking : bool:
	set(new_picking):
		picking = new_picking
		if picking:
			pick_registered.emit()
		else:
			unpick_registered.emit()
#endregion Public Variables

#region Private Variables
var _pick_target_position : Vector3
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _enter_tree() -> void:
	assert(InputMap.has_action(pick_action), "Action %s is not defined in Input Map." % pick_action)
	assert(InputMap.has_action(interact_action), "Action %s is not defined in Input Map." % interact_action)

func _physics_process(_delta : float) -> void:
	_update_last_collider()
	#_update_pick_target_position()
	
	if not picking:
		_update_last_hittable_component()
	else:
		if not is_instance_valid(last_hittable_component):
			picking = false
			return # WARNING: This should happen when the component was freed while being picked
		
		last_hittable_component.register_picking_process(_delta, _pick_target_position, _unpick_last_hittable_component)

func _input(event : InputEvent) -> void:
	if not is_instance_valid(last_hittable_component):
		return
	
	if event.is_pressed():
		last_hittable_component.register_event_pressed(event)
		event_press_registered.emit(last_hittable_component, event)
	elif event.is_released():
		last_hittable_component.register_event_released(event)
		event_released_registered.emit(last_hittable_component, event)
	
	if last_hittable_component.interactable and event.is_action_pressed(interact_action):
		last_hittable_component.register_interaction()
		interaction_registered.emit()
	
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
func _update_last_collider() -> void:
	assert(false, "This method has to be overridden.")

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
	last_hittable_component.register_pick(_pick_target_position)
	picking = true

func _unpick_last_hittable_component() -> void:
	last_hittable_component.register_unpick()
	picking = false

func _get_hittable_component(node : Node3D) -> JXP_HittableComponent:
	if node != null and node.has_meta("JXP_HittableComponentPath"):
		var component_path = node.get_meta("JXP_HittableComponentPath", null)
		return node.get_node(component_path)
	else:
		return null
#endregion Private Methods
