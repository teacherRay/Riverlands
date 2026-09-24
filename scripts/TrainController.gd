extends Node3D
class_name TrainController

@export var speed: float = 12.0 # units per second
@export var path_node: Path3D

var path_length: float = 0.0
var current_distance: float = 0.0

# References to carriages (PathFollow3D nodes)
@export var carriage_followers: Array[PathFollow3D] = []
@export var carriage_spacing: float = 3.6 # Distance between carriage pivots

func _ready() -> void:
	if path_node == null:
		path_node = get_parent() as Path3D
	
	if path_node != null and path_node.curve != null:
		path_length = path_node.curve.get_baked_length()
	
	# Auto-gather PathFollow3D children if not assigned
	if carriage_followers.is_empty():
		for child in get_children():
			if child is PathFollow3D:
				carriage_followers.append(child)

func _process(delta: float) -> void:
	if path_length <= 0.0:
		if path_node != null and path_node.curve != null:
			path_length = path_node.curve.get_baked_length()
		return
	
	current_distance = fposmod(current_distance + speed * delta, path_length)
	
	for i in range(carriage_followers.size()):
		var follower := carriage_followers[i]
		if follower != null:
			var car_dist := fposmod(current_distance - i * carriage_spacing, path_length)
			follower.progress = car_dist
