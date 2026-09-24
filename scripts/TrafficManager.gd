extends Node3D
class_name TrafficManager

# Array of vehicle followers that progress along their respective parent Path3D curves
var followers: Array[Dictionary] = [] # { "node": PathFollow3D, "speed": float, "length": float }

func _ready() -> void:
	find_and_register_vehicles(self)

func find_and_register_vehicles(node: Node) -> void:
	for child in node.get_children():
		if child is PathFollow3D:
			var parent_path := child.get_parent() as Path3D
			var curve_len := 100.0
			if parent_path != null and parent_path.curve != null:
				curve_len = parent_path.curve.get_baked_length()
			
			var spd: float = child.get_meta("speed", randf_range(6.0, 10.0))
			followers.append({
				"node": child,
				"speed": spd,
				"length": curve_len
			})
		find_and_register_vehicles(child)

func _process(delta: float) -> void:
	for entry in followers:
		var node: PathFollow3D = entry["node"]
		if is_instance_valid(node):
			var spd: float = entry["speed"]
			var curve_len: float = entry["length"]
			if curve_len > 0:
				node.progress = fposmod(node.progress + spd * delta, curve_len)
