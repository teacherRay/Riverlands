extends Node3D
class_name DuckWander

@export var swim_radius: float = 4.0
@export var swim_speed: float = 0.8

var center_pos: Vector3 = Vector3.ZERO
var angle: float = 0.0

func _ready() -> void:
	center_pos = position
	angle = randf() * TAU

func _process(delta: float) -> void:
	angle += (swim_speed / swim_radius) * delta
	var target_x := center_pos.x + cos(angle) * swim_radius
	var target_z := center_pos.z + sin(angle) * swim_radius
	
	# Turn to face swim direction
	rotation.y = -angle + PI / 2.0
	position.x = target_x
	position.z = target_z
	
	# Bobbing
	var t := Time.get_ticks_msec() / 1000.0
	position.y = center_pos.y + sin(t * 3.0) * 0.04
