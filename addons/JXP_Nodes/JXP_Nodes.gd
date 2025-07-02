@tool
extends EditorPlugin

#region Constants
const MAIN_PANEL_SCENE : PackedScene = preload("res://addons/JXP_Nodes/Editor/JXP_MainPanel.tscn")
#endregion Constants

#region Public Variables
var main_panel : Control = null
#endregion Public Variables

func _enter_tree() -> void:
	# Initialization of the plugin goes here
	main_panel = MAIN_PANEL_SCENE.instantiate()

	# Add the main panel to the editor's main viewport
	EditorInterface.get_editor_main_screen().add_child(main_panel)
	main_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	# Hide the main panel. Very much required
	_make_visible(false)

func _exit_tree() -> void:
	# Clean-up of the plugin goes here
	if main_panel:
		main_panel.queue_free()

func _has_main_screen():
	return true

func _make_visible(visible):
	# Code when the plugin's main screen tab becomes active or inactive
	if main_panel:
		main_panel.visible = visible

func _get_plugin_name():
	return "JXP"

func _get_plugin_icon():
	return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")
