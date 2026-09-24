extends Control
class_name GameHUD

var camera_ctrl: CameraController
var day_night: DayNightCycle

@onready var btn_overview: Button = %BtnOverview
@onready var btn_lake: Button = %BtnLake
@onready var btn_town: Button = %BtnTown
@onready var btn_sawmill: Button = %BtnSawmill
@onready var btn_farm: Button = %BtnFarm
@onready var btn_day_night: Button = %BtnDayNight
@onready var label_time: Label = %LabelTime

func _ready() -> void:
	camera_ctrl = get_node_or_null("/root/Main/CameraRig") as CameraController
	day_night = get_node_or_null("/root/Main/DayNightCycle") as DayNightCycle
	
	if btn_overview:
		btn_overview.pressed.connect(func(): if camera_ctrl: camera_ctrl.focus_landmark(Vector3(0, 0, 0), 85.0, -PI/4.0))
	if btn_lake:
		btn_lake.pressed.connect(func(): if camera_ctrl: camera_ctrl.focus_landmark(Vector3(0, 2, 0), 38.0, -PI/4.0))
	if btn_town:
		btn_town.pressed.connect(func(): if camera_ctrl: camera_ctrl.focus_landmark(Vector3(-38, 2, 28), 32.0, -PI/3.0))
	if btn_sawmill:
		btn_sawmill.pressed.connect(func(): if camera_ctrl: camera_ctrl.focus_landmark(Vector3(34, 2, 22), 32.0, -PI/6.0))
	if btn_farm:
		btn_farm.pressed.connect(func(): if camera_ctrl: camera_ctrl.focus_landmark(Vector3(-32, 3, -12), 32.0, -PI/2.5))
	if btn_day_night:
		btn_day_night.pressed.connect(_on_toggle_day_night)

func _process(_delta: float) -> void:
	if day_night and label_time:
		var total_hours := fmod(day_night.time_of_day * 24.0 + 6.0, 24.0) # 0.0 was midnight, offset to 6am
		var hours := int(total_hours)
		var minutes := int((total_hours - hours) * 60.0)
		label_time.text = "%02d:%02d" % [hours, minutes]

func _on_toggle_day_night() -> void:
	if day_night:
		day_night.is_paused = not day_night.is_paused
		if btn_day_night:
			btn_day_night.text = "Resume Time" if day_night.is_paused else "Pause Time"
