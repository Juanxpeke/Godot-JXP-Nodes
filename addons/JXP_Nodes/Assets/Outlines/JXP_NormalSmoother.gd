class_name JXP_NormalSmoother extends Node
## Docstring

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
## TODO.
@export var meshes_root : Node = null
#endregion Exports Variables

#region Public Variables
#endregion Public Variables

#region Private Variables
var _mdt := MeshDataTool.new()
#endregion Private Variables

#region On Ready Variables
#endregion On Ready Variables

#region Built-in Virtual Methods
func _ready() -> void:
	if meshes_root:
		_inspect_node(meshes_root)
#endregion Built-in Virtual Methods

#region Public Methods
#endregion Public Methods

#region Private Methods
func _inspect_node(node : Node) -> void:
	if node is MeshInstance3D and node.mesh is ArrayMesh and not node.mesh.has_meta("JXP_NormalSmoothed"):
		_normal_smooth(node.mesh)
	
	for child in node.get_children():
		_inspect_node(child)

func _normal_smooth(mesh : ArrayMesh) -> void:
	var surface_count : int = mesh.get_surface_count()
	
	for surface_index in surface_count:
		_mdt.clear()
		_mdt.create_from_surface(mesh, 0)
		
		var vertex_dict : Dictionary = {}
			
		for v in _mdt.get_vertex_count():
			var position := _mdt.get_vertex(v)
			
			if vertex_dict.has(position):
				var data = vertex_dict[position]
				data["vertices"].append(v)
				data["normal_sum"] += _mdt.get_vertex_normal(v)
			else:
				vertex_dict[position] = {
					"vertices": [v],
					"normal_sum": _mdt.get_vertex_normal(v)
				}
		
		for position in vertex_dict:
			var data = vertex_dict[position]
			var smooth_normal = data["normal_sum"].normalized()
			
			for v in data["vertices"]:
				_mdt.set_vertex_meta(v, Color(smooth_normal.x, smooth_normal.y, smooth_normal.z))
		
		var st = SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		st.set_material(_mdt.get_material())
		
		for f in _mdt.get_face_count():
			for idx in 3:
				var v = _mdt.get_face_vertex(f, idx)
				st.set_normal(_mdt.get_vertex_normal(v))
				st.set_uv(_mdt.get_vertex_uv(v))
				st.set_uv2(_mdt.get_vertex_uv2(v))
				st.set_tangent(_mdt.get_vertex_tangent(v))
				st.set_weights(_mdt.get_vertex_weights(v))
				st.set_bones(_mdt.get_vertex_bones(v))
				st.set_custom_format(0, SurfaceTool.CUSTOM_RGB_FLOAT)
				st.set_custom(0, _mdt.get_vertex_meta(v))
				st.add_vertex(_mdt.get_vertex(v))
		
		mesh.surface_remove(0)
		st.commit(mesh)
	
	mesh.set_meta("JXP_NormalSmoothed", true)
#endregion Private Methods
