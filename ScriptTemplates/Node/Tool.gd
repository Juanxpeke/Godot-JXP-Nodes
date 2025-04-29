# meta-name: Tool
# meta-description: Base template for a Node whose logic can run in the editor. The script is separated by regions following the Godot style guide
# meta-default: false
# meta-space-indent: 4

@tool
extends _BASE_
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
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	_ready_base()
	
	if Engine.is_editor_hint():
		_ready_editor()
	else:
		_ready_game()

func _ready_base() -> void:
	pass

func _ready_editor() -> void:
	pass

func _ready_game() -> void:
	pass

func _process(delta : float) -> void:
	_process_base(delta)

	if Engine.is_editor_hint():
		_process_editor(delta)
	else:
		_process_game(delta)

func _process_base(delta : float) -> void:
	pass

func _process_editor(delta : float) -> void:
	pass

func _process_game(delta : float) -> void:
	pass
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
#endregion Private Methods