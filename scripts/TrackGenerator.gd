@tool
extends Path3D
class_name TrackGenerator

@export var sleeper_spacing: float = 1.4
@export var sleeper_width: float = 1.8
@export var rail_gauge: float = 1.1

func _ready() -> void:
	generate_track()

func generate_track() -> void:
	if curve == null:
		return
	
	# Clear previous generated track if exists
	var old := get_node_or_null("Generated_TrackMesh")
	if old != null:
		old.queue_free()
	
	var length: float = curve.get_baked_length()
	if length <= 0.0:
		return
	
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var col_wood := Color(0.42, 0.28, 0.18, 1)
	var col_rail := Color(0.72, 0.75, 0.78, 1)
	
	var steps: int = int(length / sleeper_spacing)
	for i in range(steps):
		var dist: float = float(i) * sleeper_spacing
		var pos: Vector3 = curve.sample_baked(dist)
		var next_pos: Vector3 = curve.sample_baked(dist + 0.5)
		var fwd: Vector3 = (next_pos - pos).normalized()
		var up: Vector3 = Vector3.UP
		var right: Vector3 = fwd.cross(up).normalized()
		
		# Wooden sleeper box
		var hw: float = sleeper_width * 0.5
		var hl: float = 0.22
		var hh: float = 0.08
		
		var p0: Vector3 = pos - right * hw - fwd * hl + up * hh
		var p1: Vector3 = pos + right * hw - fwd * hl + up * hh
		var p2: Vector3 = pos + right * hw + fwd * hl + up * hh
		var p3: Vector3 = pos - right * hw + fwd * hl + up * hh
		
		st.set_color(col_wood)
		st.set_normal(up)
		st.add_vertex(p0)
		st.add_vertex(p1)
		st.add_vertex(p2)
		st.add_vertex(p0)
		st.add_vertex(p2)
		st.add_vertex(p3)

	# Build two continuous rails
	var rail_steps: int = int(length / 0.8)
	var half_g: float = rail_gauge * 0.5
	var rw: float = 0.08
	var rh: float = 0.16
	
	for i in range(rail_steps):
		var d0: float = float(i) * 0.8
		var d1: float = minf(float(i + 1) * 0.8, length)
		
		var pos0: Vector3 = curve.sample_baked(d0)
		var fwd0: Vector3 = (curve.sample_baked(d0 + 0.2) - pos0).normalized()
		var right0: Vector3 = fwd0.cross(Vector3.UP).normalized()
		
		var pos1: Vector3 = curve.sample_baked(d1)
		var fwd1: Vector3 = (curve.sample_baked(d1 + 0.2) - pos1).normalized()
		var right1: Vector3 = fwd1.cross(Vector3.UP).normalized()
		
		# Left rail
		var l0_a: Vector3 = pos0 - right0 * (half_g + rw) + Vector3.UP * rh
		var l0_b: Vector3 = pos0 - right0 * (half_g - rw) + Vector3.UP * rh
		var l1_a: Vector3 = pos1 - right1 * (half_g + rw) + Vector3.UP * rh
		var l1_b: Vector3 = pos1 - right1 * (half_g - rw) + Vector3.UP * rh
		
		st.set_color(col_rail)
		st.set_normal(Vector3.UP)
		st.add_vertex(l0_a)
		st.add_vertex(l1_a)
		st.add_vertex(l1_b)
		st.add_vertex(l0_a)
		st.add_vertex(l1_b)
		st.add_vertex(l0_b)
		
		# Right rail
		var r0_a: Vector3 = pos0 + right0 * (half_g - rw) + Vector3.UP * rh
		var r0_b: Vector3 = pos0 + right0 * (half_g + rw) + Vector3.UP * rh
		var r1_a: Vector3 = pos1 + right1 * (half_g - rw) + Vector3.UP * rh
		var r1_b: Vector3 = pos1 + right1 * (half_g + rw) + Vector3.UP * rh
		
		st.add_vertex(r0_a)
		st.add_vertex(r1_a)
		st.add_vertex(r1_b)
		st.add_vertex(r0_a)
		st.add_vertex(r1_b)
		st.add_vertex(r0_b)

	var mesh: ArrayMesh = st.commit()
	var mat := StandardMaterial3D.new()
	mat.vertex_color_use_as_albedo = true
	mat.roughness = 0.6
	
	var mesh_inst := MeshInstance3D.new()
	mesh_inst.name = "Generated_TrackMesh"
	mesh_inst.mesh = mesh
	mesh_inst.material_override = mat
	add_child(mesh_inst)
