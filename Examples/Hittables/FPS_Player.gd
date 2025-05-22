extends CharacterBody3D
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
## TODO
const WALKING_SPEED                          : float = 4.0
## TODO
const HEAD_HORIZONTAL_ROTATION_SPEED         : float = 0.003
## TODO
const HEAD_VERTICAL_ROTATION_SPEED           : float = 0.002
## TODO
const MAXIMUM_HEAD_HORIZONTAL_DELTA_ROTATION : float = 0.25
## TODO
const MAXIMUM_HEAD_VERTICAL_DELTA_ROTATION   : float = 0.25
## TODO
const MAXIMUM_HEAD_VERTICAL_ROTATION         : float = deg_to_rad(72)
## TODO
const CROUCHING_DOWN_SPEED                   : float = 4.5
## TODO
const CROUCHING_SPEED                        : float = 1.6
## TODO
const CROUCHING_LOCKED_CHECK_DELTA_TIME      : float = 0.05
#endregion Constants

#region Exports Variables
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
#endregion Private Variables

#region On Ready Variables
@onready var _head_pivot : Node3D = %HeadPivot
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	var input_direction : Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")

	var forward := transform.basis.z
	var right   := transform.basis.x
	
	var movement_direction := Vector2(forward.x, forward.z) * input_direction.y + Vector2(right.x, right.z) * input_direction.x
	
	var movement_speed := WALKING_SPEED
	
	var velocity_xz = movement_direction * movement_speed # WARNING: This should not be delta dependent (?)
	
	velocity = Vector3(velocity_xz.x, velocity.y, velocity_xz.y)
	
	velocity += get_gravity() * delta

	move_and_slide()

func _input(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		var horizontal_rotation : float = event.relative.x * HEAD_HORIZONTAL_ROTATION_SPEED * -1
		var vertical_rotation   : float = event.relative.y *   HEAD_VERTICAL_ROTATION_SPEED * -1
		
		horizontal_rotation = clamp(horizontal_rotation, -MAXIMUM_HEAD_HORIZONTAL_DELTA_ROTATION, MAXIMUM_HEAD_HORIZONTAL_DELTA_ROTATION)
		vertical_rotation   = clamp(  vertical_rotation,   -MAXIMUM_HEAD_VERTICAL_DELTA_ROTATION,   MAXIMUM_HEAD_VERTICAL_DELTA_ROTATION)
		
		rotate_y(horizontal_rotation)
		_head_pivot.rotate_x(vertical_rotation)
		_head_pivot.rotation.x = clamp(_head_pivot.rotation.x, -MAXIMUM_HEAD_VERTICAL_ROTATION, MAXIMUM_HEAD_VERTICAL_ROTATION)
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods
