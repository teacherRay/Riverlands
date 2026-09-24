extends Node3D
class_name WaterBob

@export var bob_amplitude: float = 0.08
@export var bob_frequency: float = 1.5
@export var tilt_amplitude: float = 0.03
@export var tilt_frequency: float = 1.2

var base_y: float = 0.0
var time_offset: float = 0.0

func _ready() -> void:
	base_y = position.y
	time_offset = randf_range(0.0, 10.0)

func _process(delta: float) -> void:
	var t := Time.get_ticks_msec() / 1000.0 + time_offset
	position.y = base_y + sin(t * bob_frequency) * bob_amplitude
	rotation.z = sin(t * tilt_frequency) * tilt_amplitude
	rotation.x = cos(t * tilt_frequency * 0.8) * tilt_amplitude * 0.6
