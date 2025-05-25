@tool
extends Node3D
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
@export var outline_material : ShaderMaterial:
	set(new_outline_material):
		outline_material = new_outline_material
		_update_overlay_materials(_nodes)
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
var _nodes : Node3D = null
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _init() -> void:
	_nodes = Node3D.new()
	add_child(_nodes)
	
	var cube_mesh_instance := MeshInstance3D.new()
	cube_mesh_instance.mesh = _create_array_mesh(BoxMesh.new())
	_nodes.add_child(cube_mesh_instance)
	
	var sphere_mesh_instance := MeshInstance3D.new()
	sphere_mesh_instance.mesh = _create_array_mesh(SphereMesh.new())
	_nodes.add_child(sphere_mesh_instance)
	
	var cylinder_mesh_instance := MeshInstance3D.new()
	cylinder_mesh_instance.mesh = _create_array_mesh(CylinderMesh.new())
	_nodes.add_child(cylinder_mesh_instance)
	
	var pirate_packed_scene : PackedScene = load("uid://dbi14hje4sfij")
	var pirate_root_node := pirate_packed_scene.instantiate()
	_nodes.add_child(pirate_root_node)

func _ready() -> void:
	for i in _nodes.get_child_count():
		_nodes.get_child(i).global_position = Vector3(i * 2.5, 0, 0)
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func _create_array_mesh(primitive_mesh : PrimitiveMesh) -> ArrayMesh:
	var array_mesh := ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, primitive_mesh.get_mesh_arrays())
	return array_mesh

func _update_overlay_materials(node : Node) -> void:
	if node is MeshInstance3D:
		node.material_overlay = outline_material
	for child in node.get_children():
		_update_overlay_materials(child)
#endregion Private Methods
