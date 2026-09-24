@tool
extends Node3D
class_name IslandGenerator

@export var island_radius: float = 62.0
@export var grid_resolution: int = 100 # 100x100 grid

func _ready() -> void:
	generate_world()

func generate_world() -> void:
	# Clear previous generated children if any
	for child in get_children():
		if child.name.begins_with("Generated_"):
			child.queue_free()
	
	create_terrain_mesh()
	create_ocean_mesh()
	create_lake_mesh()

func get_elevation(x: float, z: float) -> float:
	var dist: float = sqrt(x * x + z * z)
	
	# Outside island perimeter: slopes into ocean
	if dist > island_radius + 8.0:
		return -4.0
	elif dist > island_radius:
		var t: float = (dist - island_radius) / 8.0
		return lerpf(0.2, -4.0, t)
	
	# Base island elevation (beaches rise to gentle rolling plateau)
	var norm_dist: float = dist / island_radius
	var h: float = 0.6 + (1.0 - norm_dist) * 2.8
	
	# Rolling terrain variation using sine harmonics
	h += sin(x * 0.12) * cos(z * 0.12) * 0.8
	h += sin(x * 0.25 + 1.2) * sin(z * 0.25) * 0.4
	
	# Northern Mountain Range 1 (North-West peak)
	var d_mtn1: float = Vector2(x - (-20.0), z - (-36.0)).length()
	if d_mtn1 < 22.0:
		var m1: float = (1.0 - d_mtn1 / 22.0)
		h += m1 * m1 * 12.0
	
	# Northern Mountain Range 2 (North-East peak)
	var d_mtn2: float = Vector2(x - 22.0, z - (-38.0)).length()
	if d_mtn2 < 24.0:
		var m2: float = (1.0 - d_mtn2 / 24.0)
		h += m2 * m2 * 14.5
	
	# North central peak (with tunnel)
	var d_mtn3: float = Vector2(x - 2.0, z - (-46.0)).length()
	if d_mtn3 < 18.0:
		var m3: float = (1.0 - d_mtn3 / 18.0)
		h += m3 * m3 * 11.0

	# West coastal ridge
	var d_ridge: float = Vector2(x - (-38.0), z - (-12.0)).length()
	if d_ridge < 16.0:
		var mr: float = (1.0 - d_ridge / 16.0)
		h += mr * mr * 6.5

	# Central Freshwater Lake depression (centered around 0, 0)
	var lake_dist: float = Vector2(x, z).length()
	if lake_dist < 18.0:
		# Check for small central lake islands
		var d_isle1: float = Vector2(x - (-2.0), z - 2.0).length()
		var d_isle2: float = Vector2(x - 7.0, z - (-4.0)).length()
		if d_isle1 < 3.2:
			h = 2.4 + (1.0 - d_isle1 / 3.2) * 1.0 # Lake island 1
		elif d_isle2 < 2.5:
			h = 2.3 + (1.0 - d_isle2 / 2.5) * 0.8 # Lake island 2
		else:
			var lake_factor: float = clampf((18.0 - lake_dist) / 10.0, 0.0, 1.0)
			h = lerpf(h, 1.0, lake_factor)

	# Southwest River trench (flows from central lake to SW coast)
	var river_sw_dist: float = distance_to_segment(Vector2(x, z), Vector2(-10.0, 8.0), Vector2(-42.0, 36.0))
	if river_sw_dist < 5.0 and dist < island_radius - 2.0:
		var t_carve: float = 1.0 - (river_sw_dist / 5.0)
		# Bed slopes gently from 1.3 at lake to 0.1 at sea
		var progress: float = clampf((x - (-10.0)) / (-32.0), 0.0, 1.0)
		var bed_h: float = lerpf(1.2, 0.0, progress)
		h = lerpf(h, bed_h, t_carve * 0.9)

	# Southeast River trench (flows through gorge/waterfall to SE coast)
	var river_se_dist: float = distance_to_segment(Vector2(x, z), Vector2(10.0, 6.0), Vector2(36.0, 34.0))
	if river_se_dist < 4.8 and dist < island_radius - 2.0:
		var t_carve: float = 1.0 - (river_se_dist / 4.8)
		var progress: float = clampf((x - 10.0) / 26.0, 0.0, 1.0)
		var bed_h: float = lerpf(1.2, 0.0, progress)
		h = lerpf(h, bed_h, t_carve * 0.9)

	# North River / stream
	var river_n_dist: float = distance_to_segment(Vector2(x, z), Vector2(0.0, -14.0), Vector2(0.0, -56.0))
	if river_n_dist < 3.8 and dist < island_radius - 2.0:
		var t_carve: float = 1.0 - (river_n_dist / 3.8)
		var progress: float = clampf((-z - 14.0) / 42.0, 0.0, 1.0)
		var bed_h: float = lerpf(1.2, 0.0, progress)
		h = lerpf(h, bed_h, t_carve * 0.85)

	return h

func get_terrain_color(x: float, z: float, y: float) -> Color:
	var dist: float = sqrt(x * x + z * z)
	
	# Underwater / seabed
	if y <= 0.2:
		return Color(0.82, 0.76, 0.62) # Wet sand
	# Shoreline / beach
	elif y < 1.3 and dist > 46.0:
		return Color(0.96, 0.86, 0.65) # Warm beach sand
	# High rocky mountain peaks
	elif y > 6.5:
		var rock_shade: float = randf_range(0.52, 0.62)
		return Color(rock_shade, rock_shade + 0.02, rock_shade + 0.04)
	# Farmland golden wheat fields
	elif (x > -40.0 and x < -20.0 and z > -18.0 and z < -2.0) or (x > 24.0 and x < 42.0 and z > -16.0 and z < 0.0):
		# Golden crop field with subtle furrows
		var furrow: float = sin(z * 4.0) * 0.03
		return Color(0.95 + furrow, 0.78 + furrow, 0.25)
	# Default lush island grass
	else:
		# Subtle variations in bright natural greens
		var g_var: float = sin(x * 0.3) * cos(z * 0.3) * 0.04
		return Color(0.38 + g_var, 0.68 + g_var, 0.22)

func create_terrain_mesh() -> void:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var step: float = (island_radius * 2.4) / float(grid_resolution)
	var half_size: float = (island_radius * 2.4) * 0.5
	
	# Generate grid points with slight jitter for natural low-poly triangulation
	var heights: Array[Array] = []
	for iz in range(grid_resolution + 1):
		var row: Array[Vector3] = []
		for ix in range(grid_resolution + 1):
			var x: float = -half_size + ix * step
			var z: float = -half_size + iz * step
			# Low-poly jitter on inner island
			var jx: float = 0.0
			var jz: float = 0.0
			if ix > 0 and ix < grid_resolution and iz > 0 and iz < grid_resolution:
				jx = sin(ix * 13.7 + iz * 29.3) * step * 0.28
				jz = cos(ix * 31.1 + iz * 17.5) * step * 0.28
			var px: float = x + jx
			var pz: float = z + jz
			var py: float = get_elevation(px, pz)
			row.append(Vector3(px, py, pz))
		heights.append(row)

	# Build flat-shaded triangles (unshared vertices for crisp facets)
	for iz in range(grid_resolution):
		for ix in range(grid_resolution):
			var p0: Vector3 = heights[iz][ix]
			var p1: Vector3 = heights[iz][ix + 1]
			var p2: Vector3 = heights[iz + 1][ix]
			var p3: Vector3 = heights[iz + 1][ix + 1]
			
			# Triangle 1: p0, p1, p2
			var norm1: Vector3 = (p1 - p0).cross(p2 - p0).normalized()
			var c1: Color = get_terrain_color((p0.x + p1.x + p2.x) / 3.0, (p0.z + p1.z + p2.z) / 3.0, (p0.y + p1.y + p2.y) / 3.0)
			st.set_color(c1)
			st.set_normal(norm1)
			st.add_vertex(p0)
			st.add_vertex(p1)
			st.add_vertex(p2)
			
			# Triangle 2: p1, p3, p2
			var norm2: Vector3 = (p3 - p1).cross(p2 - p1).normalized()
			var c2: Color = get_terrain_color((p1.x + p3.x + p2.x) / 3.0, (p1.z + p3.z + p2.z) / 3.0, (p1.y + p3.y + p2.y) / 3.0)
			st.set_color(c2)
			st.set_normal(norm2)
			st.add_vertex(p1)
			st.add_vertex(p3)
			st.add_vertex(p2)

	var array_mesh: ArrayMesh = st.commit()
	var mat := StandardMaterial3D.new()
	mat.vertex_color_use_as_albedo = true
	mat.roughness = 0.88
	
	var mesh_inst := MeshInstance3D.new()
	mesh_inst.name = "Generated_Terrain"
	mesh_inst.mesh = array_mesh
	mesh_inst.material_override = mat
	add_child(mesh_inst)

func create_ocean_mesh() -> void:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var ocean_rad: float = island_radius * 1.8
	var segments: int = 48
	var center := Vector3(0, 0.0, 0)
	var col_water := Color(0.11, 0.46, 0.82, 0.88)
	
	for i in range(segments):
		var a1: float = float(i) / float(segments) * TAU
		var a2: float = float(i + 1) / float(segments) * TAU
		var v1 := Vector3(cos(a1) * ocean_rad, 0.0, sin(a1) * ocean_rad)
		var v2 := Vector3(cos(a2) * ocean_rad, 0.0, sin(a2) * ocean_rad)
		
		st.set_color(col_water)
		st.set_normal(Vector3.UP)
		st.add_vertex(center)
		st.add_vertex(v1)
		st.add_vertex(v2)
	
	var ocean_mesh: ArrayMesh = st.commit()
	var mat := StandardMaterial3D.new()
	mat.vertex_color_use_as_albedo = true
	mat.roughness = 0.15
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	
	var mesh_inst := MeshInstance3D.new()
	mesh_inst.name = "Generated_Ocean"
	mesh_inst.mesh = ocean_mesh
	mesh_inst.material_override = mat
	add_child(mesh_inst)

func create_lake_mesh() -> void:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var lake_rad: float = 17.5
	var segments: int = 32
	var center := Vector3(0, 1.55, 0)
	var col_lake := Color(0.14, 0.54, 0.82, 0.9)
	
	for i in range(segments):
		var a1: float = float(i) / float(segments) * TAU
		var a2: float = float(i + 1) / float(segments) * TAU
		var v1 := Vector3(cos(a1) * lake_rad, 1.55, sin(a1) * lake_rad)
		var v2 := Vector3(cos(a2) * lake_rad, 1.55, sin(a2) * lake_rad)
		
		st.set_color(col_lake)
		st.set_normal(Vector3.UP)
		st.add_vertex(center)
		st.add_vertex(v1)
		st.add_vertex(v2)
	
	var lake_mesh: ArrayMesh = st.commit()
	var mat := StandardMaterial3D.new()
	mat.vertex_color_use_as_albedo = true
	mat.roughness = 0.1
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	
	var mesh_inst := MeshInstance3D.new()
	mesh_inst.name = "Generated_Lake"
	mesh_inst.mesh = lake_mesh
	mesh_inst.material_override = mat
	add_child(mesh_inst)

func distance_to_segment(p: Vector2, a: Vector2, b: Vector2) -> float:
	var ab: Vector2 = b - a
	var ab_len_sq: float = ab.length_squared()
	if ab_len_sq == 0.0:
		return p.distance_to(a)
	var t: float = clampf((p - a).dot(ab) / ab_len_sq, 0.0, 1.0)
	var proj: Vector2 = a + ab * t
	return p.distance_to(proj)
