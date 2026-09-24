@tool
extends Path3D
class_name RoadGenerator

@export var road_width: float = 2.4

func _ready() -> void:
	generate_road()

func generate_road() -> void:
	if curve == null:
		return
	
	var old := get_node_or_null("Generated_RoadMesh")
	if old != null:
		old.queue_free()
	
	var length: float = curve.get_baked_length()
	if length <= 0.0:
		return
	
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var col_road := Color(0.38, 0.4, 0.42, 1) # Paved asphalt
	var col_curb := Color(0.75, 0.72, 0.65, 1) # Light curb edge
	
	var steps: int = int(length / 0.8)
	var half_w: float = road_width * 0.5
	
	for i in range(steps):
		var d0: float = float(i) * 0.8
		var d1: float = minf(float(i + 1) * 0.8, length)
		
		var pos0: Vector3 = curve.sample_baked(d0)
		var fwd0: Vector3 = (curve.sample_baked(d0 + 0.2) - pos0).normalized()
		var right0: Vector3 = fwd0.cross(Vector3.UP).normalized()
		
		var pos1: Vector3 = curve.sample_baked(d1)
		var fwd1: Vector3 = (curve.sample_baked(d1 + 0.2) - pos1).normalized()
		var right1: Vector3 = fwd1.cross(Vector3.UP).normalized()
		
		var l0: Vector3 = pos0 - right0 * half_w + Vector3.UP * 0.04
		var r0: Vector3 = pos0 + right0 * half_w + Vector3.UP * 0.04
		var l1: Vector3 = pos1 - right1 * half_w + Vector3.UP * 0.04
		var r1: Vector3 = pos1 + right1 * half_w + Vector3.UP * 0.04
		
		st.set_color(col_road)
		st.set_normal(Vector3.UP)
		st.add_vertex(l0)
		st.add_vertex(r1)
		st.add_vertex(r0)
		st.add_vertex(l0)
		st.add_vertex(l1)
		st.add_vertex(r1)
	
	var mesh: ArrayMesh = st.commit()
	var mat := StandardMaterial3D.new()
	mat.vertex_color_use_as_albedo = true
	mat.roughness = 0.92
	
	var mesh_inst := MeshInstance3D.new()
	mesh_inst.name = "Generated_RoadMesh"
	mesh_inst.mesh = mesh
	mesh_inst.material_override = mat
	add_child(mesh_inst)
