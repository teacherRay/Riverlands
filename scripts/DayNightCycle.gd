extends Node3D
class_name DayNightCycle

@export var day_length_seconds: float = 180.0 # 3 minutes full day cycle
@export var is_paused: bool = false
@export var time_of_day: float = 0.28 # Start in morning (~10 AM)

@onready var sun: DirectionalLight3D = $DirectionalLight3D
@onready var environment: WorldEnvironment = $WorldEnvironment

func _process(delta: float) -> void:
	if not is_paused:
		time_of_day += delta / day_length_seconds
		if time_of_day >= 1.0:
			time_of_day -= 1.0
	
	update_lighting()

func update_lighting() -> void:
	if sun == null:
		return
	
	# Sun rotation: 0.0 = midnight, 0.25 = sunrise, 0.5 = noon, 0.75 = sunset
	var sun_angle := (time_of_day - 0.25) * TAU
	sun.rotation.x = -sin(sun_angle) * 1.1 - 0.2
	sun.rotation.y = cos(sun_angle) * 0.8 + PI / 4.0
	
	# Color and energy transitions
	var altitude := -sin(sun_angle)
	if altitude > 0.1:
		# Day
		sun.light_energy = clamp(altitude * 1.5, 0.0, 1.2)
		sun.light_color = Color(1.0, 0.98, 0.92) # Warm sunlight
	elif altitude > -0.1:
		# Dawn / Sunset (Golden hour)
		var t := (altitude + 0.1) / 0.2
		sun.light_energy = lerp(0.1, 0.9, t)
		sun.light_color = Color(1.0, 0.65, 0.35) # Golden orange
	else:
		# Night
		sun.light_energy = 0.08
		sun.light_color = Color(0.4, 0.5, 0.8) # Soft cool moonlight
