class_name JXP_NormalSmoother extends Node
## Container of static functions used for normal smoothing.

#region Signals
#endregion Signals

#region Enums
#endregion Enums

#region Constants
#endregion Constants

#region Exports Variables
#endregion Exports Variables

#region Static Variables
static var _mdt : MeshDataTool
#endregion Static Variables

#region Static Methods
static func smooth_node(node : Node, recursive : bool = true) -> void:
	if node is MeshInstance3D and node.mesh is ArrayMesh and not node.mesh.has_meta("JXP_NormalSmoothed"):
		JXP_NormalSmoother.normal_smooth(node.mesh)
	
	if recursive:
		for child in node.get_children():
			smooth_node(child)

static func normal_smooth(mesh : ArrayMesh) -> void:
	if _mdt == null:
		_mdt = MeshDataTool.new()
	
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
#endregion Static Methods
