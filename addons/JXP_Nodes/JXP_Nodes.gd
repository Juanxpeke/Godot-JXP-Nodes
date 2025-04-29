@tool
extends EditorPlugin

var button

func _enter_tree() -> void:
	# Initialization of the plugin goes here.

	button = Button.new()
	button.text = "Hello, World!"
	button.pressed.connect(_on_button_pressed)
	#add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UL, button)

func _on_button_pressed():
	print("Hello, World!")


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_control_from_docks(button)
	# Free button
	button.free()
