extends Node3D
class_name CameraController

@export var move_speed: float = 40.0
@export var zoom_speed: float = 5.0
@export var min_zoom: float = 15.0
@export var max_zoom: float = 140.0
@export var rotate_speed: float = 2.0

var target_position: Vector3 = Vector3(0, 0, 0)
var target_rotation_y: float = -PI / 4.0 # 45 degrees isometric angle
var target_pitch: float = -0.65 # ~37 degrees isometric tilt
var target_zoom: float = 75.0

@onready var yaw_pivot: Node3D = self
var camera: Camera3D

var is_dragging: bool = false
var drag_last_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	camera = get_node_or_null("Camera3D")
	if camera == null:
		for child in get_children():
			if child is Camera3D:
				camera = child
				break
	target_position = position
	target_rotation_y = rotation.y
	if camera != null:
		target_zoom = camera.position.z

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom = clamp(target_zoom - zoom_speed, min_zoom, max_zoom)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom = clamp(target_zoom + zoom_speed, min_zoom, max_zoom)
		elif event.button_index == MOUSE_BUTTON_RIGHT or event.button_index == MOUSE_BUTTON_MIDDLE:
			is_dragging = event.pressed
			drag_last_pos = event.position
	elif event is InputEventMouseMotion and is_dragging:
		var delta: Vector2 = event.position - drag_last_pos
		drag_last_pos = event.position
		# Orbit rotation with mouse
		target_rotation_y -= delta.x * 0.005
		target_pitch = clamp(target_pitch - delta.y * 0.005, -1.3, -0.2)

func _process(delta: float) -> void:
	# Keyboard movement
	var input_dir := Vector3.ZERO
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		input_dir.z -= 1.0
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		input_dir.z += 1.0
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		input_dir.x -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		input_dir.x += 1.0
	
	if Input.is_key_pressed(KEY_Q):
		target_rotation_y += rotate_speed * delta
	if Input.is_key_pressed(KEY_E):
		target_rotation_y -= rotate_speed * delta
	if Input.is_key_pressed(KEY_R):
		target_zoom = clamp(target_zoom - zoom_speed * 10.0 * delta, min_zoom, max_zoom)
	if Input.is_key_pressed(KEY_F):
		target_zoom = clamp(target_zoom + zoom_speed * 10.0 * delta, min_zoom, max_zoom)

	# Landmark presets
	if Input.is_key_pressed(KEY_1):
		focus_landmark(Vector3(0, 0, 0), 85.0, -PI/4.0) # Island overview
	elif Input.is_key_pressed(KEY_2):
		focus_landmark(Vector3(0, 2, 0), 38.0, -PI/4.0) # Central lake
	elif Input.is_key_pressed(KEY_3):
		focus_landmark(Vector3(-38, 2, 28), 32.0, -PI/3.0) # SW town & viaduct
	elif Input.is_key_pressed(KEY_4):
		focus_landmark(Vector3(34, 2, 22), 32.0, -PI/6.0) # Sawmill & forest
	elif Input.is_key_pressed(KEY_5):
		focus_landmark(Vector3(-32, 3, -12), 32.0, -PI/2.5) # Farm & windmill

	if input_dir.length_squared() > 0:
		input_dir = input_dir.normalized()
		# Transform direction relative to camera yaw
		var forward := -global_transform.basis.z
		forward.y = 0
		forward = forward.normalized()
		var right := global_transform.basis.x
		right.y = 0
		right = right.normalized()
		var move_vec := (forward * (-input_dir.z) + right * input_dir.x) * move_speed * delta
		target_position += move_vec
		# Clamp within island bounds
		target_position.x = clamp(target_position.x, -70.0, 70.0)
		target_position.z = clamp(target_position.z, -70.0, 70.0)

	# Smooth lerp
	position = position.lerp(target_position, 10.0 * delta)
	rotation.y = lerp_angle(rotation.y, target_rotation_y, 8.0 * delta)
	rotation.x = lerp(rotation.x, target_pitch, 8.0 * delta)
	
	if camera != null:
		camera.position.z = lerp(camera.position.z, target_zoom, 8.0 * delta)

func focus_landmark(pos: Vector3, zoom: float, yaw: float) -> void:
	target_position = pos
	target_zoom = zoom
	target_rotation_y = yaw
	target_pitch = -0.65
