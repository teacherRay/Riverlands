extends Node3D
class_name Rotator

@export var rotation_axis: Vector3 = Vector3(0, 0, 1) # e.g. Z for windmill/waterwheel, Y for lighthouse
@export var speed: float = 1.0 # radians per second

func _process(delta: float) -> void:
	rotate(rotation_axis.normalized(), speed * delta)
