class_name JXP_HittableComponent extends Node
## A component that can make a [CollisionObject3D] detectable by a [HittableTracker].
##
## [HittableComponent] is very cool.
## [b]Almost useless without:[/b] [JXP_HitRegistrar].

#region Signals
## Emitted when the ray starts colliding with [member collision_object].
signal hit
## Emitted when the ray stops colliding with [member collision_object].
## [b]Note:[/b] This signal won't be emitted when [member collision_object] is freed.
signal unhit
## TODO
signal event_pressed(event : InputEvent)
## TODO
signal event_released(event : InputEvent)
## Emitted when [member collision_object] is interacted with.
## Requires [member interactable] to be set to [code]true[/code].
## See also [member interactable].
signal interacted
## Emitted when [member collision_object] is picked.
## Requires [member pickable] to be set to [code]true[/code].
## See also [member pickable].
signal picked
## Emitted when [member collision_object] is unpicked.
## Requires [member pickable] to be set to [code]true[/code].
## See also [member pickable].
## [b]Note:[/b] This signal won't be emitted when [member collision_object] is freed.
signal unpicked
## Emitted when [member collision_object] [member RigidBody3D.can_sleep] property is restored to
## its initial value after being unpicked.
## See also [constant CAN_SLEEP_RESTORATION_TIME].
## [b]Note:[/b] This signal is intended to be catched only for debugging purposes.
signal can_sleep_restored
#endregion Signals

#region Enums
#endregion Enums

#region Constants
## See also [member pickable].
const INITIAL_DRAG_SPEED : float = 18.0
## See also [member pickable].
const MAXIMUM_DRAG_SPEED : float = 40.0
## See also [member pickable].
const MAXIMUM_COLLIDING_DRAG_SPEED : float = 2.5
## See also [member pickable].
const MAXIMUM_DRAG_DISTANCE : float = 1.2
## Time that has to pass in order for [member collision_object] [member RigidBody3D.can_sleep]
## property to be restored to its initial value after being unpicked.
## See also [member pickable].
const CAN_SLEEP_RESTORATION_TIME : float = 1.0
#endregion Constants

#region Exports Variables
## [CollisionObject3D] that will be put in the ray's layer in order to be detected.
@export var collision_object : CollisionObject3D
## [MeshInstance3D] that visually represents [member collision_object].
@export var mesh_instance : MeshInstance3D

@export_group("Interaction")
## If [code]true[/code], [member collision_object] can be interacted with when the action
## [code]"interact"[/code] is pressed.
@export var interactable : bool = false
## Name that can be shown as a hint while [member being_hit].
@export var interaction_name : String = "Interact"
## Default sound that will be played when [member collision_object] is interacted with.
## For more advanced behaviour, use [signal interacted].
@export var interact_sound : AudioStream

@export_group("Picking")
## If [code]true[/code], [member collision_object] will follow the player's hand while the action
## [code]"pick"[/code] is being pressed.
## Requires [member collision_object] to be an instance of [RigidBody3D].
## [b]Note:[/b] At the moment [member collision_object] is picked, its variable [member RigidBody3D.can_sleep]
## value is set to [code]true[/code] automatically, and is restored after [constant CAN_SLEEP_RESTORATION_TIME]
## seconds.
@export var pickable : bool = false
## Default sound that will be played when [member collision_object] is picked.
## For more advanced behaviour, use [signal picked]. 
@export var pick_sound : AudioStream
## Default sound that will be played when [member collision_object] is picked.
## For more advanced behaviour, use [signal unpicked].
@export var unpick_sound : AudioStream
#endregion Exports Variables

#region Static Variables
#endregion Static Variables

#region Public Variables
## If [code]true[/code], [member collision_object] is being hit by the ray in the current frame.
## [b]Note:[/b] This variable must not be modified.
var being_hit : bool = false
## If [code]true[/code], [member collision_object] is being picked.
## See also [member pickable].
## [b]Note:[/b] This variable must not be modified.
var being_picked : bool = false
#endregion Public Variables

#region Private Variables
var _player_pick_initial_rotation       : float = 0.0
var _object_pick_initial_rotation       : float = 0.0
var _object_pick_initial_angle_to_hand  : float = 0.0
var _object_pick_initial_can_sleep      : bool  = true
var _object_can_sleep_restoration_timer : Timer
#endregion Private Variables

#region On Ready Variables
@export var highlight_material : Material
#endregion On Ready Variables

#region Built-in Virtual Methods
func _init() -> void:
	add_to_group("JXP_HittableComponent")
	
	tree_exited.connect(_on_tree_exited)

func _enter_tree() -> void:
	_assert_and_force_properties()
	
	if pickable:
		_object_can_sleep_restoration_timer = Timer.new()
		_object_can_sleep_restoration_timer.wait_time = CAN_SLEEP_RESTORATION_TIME
		_object_can_sleep_restoration_timer.one_shot = true
		_object_can_sleep_restoration_timer.timeout.connect(_on_object_can_sleep_restoration_timer_timeout)
		add_child(_object_can_sleep_restoration_timer)
#endregion Built-in Virtual Methods

#region Public Methods
## TODO
func register_hit() -> void:
	being_hit = true
	
	if mesh_instance:
		mesh_instance.material_overlay = highlight_material
	
	hit.emit()
## TODO
func unregister_hit() -> void:
	being_hit = false
	
	if mesh_instance:
		mesh_instance.material_overlay = null
	
	unhit.emit()
## TODO
func register_event_pressed(event : InputEvent) -> void:
	event_pressed.emit(event)
## TODO
func register_event_released(event : InputEvent) -> void:
	event_released.emit(event)
## TODO
func register_interaction() -> void:
	if interact_sound:
		pass
		#AudioManager.play_sound(interact_sound)
	interacted.emit()
## TODO
func register_pick(hand_position : Vector3) -> void:
	being_picked = true
	
	var object : RigidBody3D = collision_object as RigidBody3D
	
	var object_vector := object.global_transform.origin #- GameManager.player.global_transform.origin
	var hand_vector   :=                  hand_position #- GameManager.player.global_transform.origin
	
	var object_vector_xz := Vector2(object_vector.x, object_vector.z)
	var hand_vector_xz   := Vector2(  hand_vector.x,   hand_vector.z)
	
	_player_pick_initial_rotation      = 0#GameManager.player.rotation.y
	_object_pick_initial_rotation      = object.rotation.y
	_object_pick_initial_angle_to_hand = object_vector_xz.angle_to(hand_vector_xz)
	
	if _object_can_sleep_restoration_timer.is_stopped():
		_object_pick_initial_can_sleep = object.can_sleep
	_object_can_sleep_restoration_timer.stop()
	
	object.can_sleep = false
	object.lock_rotation = true
	
	if mesh_instance:
		mesh_instance.material_overlay = null
	
	if pick_sound:
		pass #AudioManager.play_sound(pick_sound)
	
	picked.emit()
## TODO
func register_unpick() -> void:
	being_picked = false
	
	var object : RigidBody3D = collision_object as RigidBody3D
	
	_object_can_sleep_restoration_timer.start()
	
	object.lock_rotation = false
	
	if mesh_instance and being_hit:
		mesh_instance.material_overlay = highlight_material
	
	if unpick_sound:
		pass #AudioManager.play_sound(unpick_sound)
	
	unpicked.emit()

func register_picking_process(_delta : float, hand_position : Vector3, unpick_callback : Callable) -> void:
	var object : RigidBody3D = collision_object as RigidBody3D
	
	var object_position := object.global_transform.origin
	
	var drag_vector := hand_position - object_position
	var drag_length := drag_vector.length()
	
	# If the object is too far, it must be dropped
	if drag_length > MAXIMUM_DRAG_DISTANCE:
		object.set_linear_velocity(Vector3.ZERO)
		unpick_callback.call()  # WARNING: If the object is too big, it's picked and dropped, as the
								#          distance between the hand and the object center is too big
	# If not, it should be dragged to the player's hand
	else:
		var drag_direction := drag_vector / drag_length
		
		# The drag speed depends on the object's mass and its distance
		var mass_factor     : float = min(1.0 / object.mass, 1.0)
		var distance_factor : float = drag_length
		
		var drag_speed := distance_factor * mass_factor * INITIAL_DRAG_SPEED
		
		# If object is colliding, reduce drag speed so it doesn't push heavy objects so easily
		if object.get_contact_count() > 0:
			drag_speed /= 1 # TODO: Solve this, dividing the speed entirely causes a bug in which
							#       heavy objects can't be lifted due to collision with the ground
		
		drag_speed = min(drag_speed, MAXIMUM_DRAG_SPEED)
		
		object.set_linear_velocity(drag_direction * drag_speed)
		
		# Maintain object's rotation relative to the player
		var object_vector := object_position #- GameManager.player.global_transform.origin
		var hand_vector   :=   hand_position #- GameManager.player.global_transform.origin
		
		var object_vector_xz := Vector2(object_vector.x, object_vector.z)
		var hand_vector_xz   := Vector2(  hand_vector.x,   hand_vector.z)
		
		var object_angle_to_hand := object_vector_xz.angle_to(hand_vector_xz) 
		
		var object_front_rotation = _object_pick_initial_rotation #+ (GameManager.player.rotation.y - _player_pick_initial_rotation)
		
		object.rotation.y = object_front_rotation + (object_angle_to_hand - _object_pick_initial_angle_to_hand)
#endregion Public Methods

#region Private Methods
#region Assertions
func _assert_and_force_properties() -> void:
	assert(collision_object)
	assert(not collision_object.has_meta("JXP_HittableComponentPath"))
	
	collision_object.set_meta("JXP_HittableComponentPath", collision_object.get_path_to(self, true))
	
	if pickable:
		assert(collision_object is RigidBody3D)
		# NOTE: This is necessary for collision detection
		#       (https://docs.godotengine.org/en/stable/classes/class_rigidbody3d.html#class-rigidbody3d-method-get-colliding-bodies)
		if not collision_object.contact_monitor:
			collision_object.contact_monitor = true
		if not collision_object.max_contacts_reported > 0:
			collision_object.max_contacts_reported = 1
#endregion Assertions
#region Callbacks
func _on_tree_exited() -> void:
	if being_picked:
		being_picked = false

func _on_object_can_sleep_restoration_timer_timeout() -> void:
	var object : RigidBody3D = collision_object as RigidBody3D
	object.can_sleep = _object_pick_initial_can_sleep
	can_sleep_restored.emit()
#endregion Callbacks
#endregion Private Methods

#region Inner Classes
## TODO
class PickData:
	var pick_target_position : Vector3
	var unpick_callback : Callable
	var colliding_with_player : bool = false
#endregion Inner Classes
