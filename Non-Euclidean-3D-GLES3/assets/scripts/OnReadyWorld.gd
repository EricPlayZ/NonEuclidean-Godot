extends Spatial

var mouse_captured : bool = false
var FPSToggled : bool = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true
	OS.set_window_title("Non-Euclidean 3D")

func _process(delta):
	var current_res = OS.get_screen_size()
	ProjectSettings.set("display/window/size/width", current_res.x)
	ProjectSettings.set("display/window/size/height", current_res.y)
	var FPSCounter : int = Engine.get_frames_per_second()

	if FPSToggled:
		$FPS/VBoxContainer/Label.text = str(FPSCounter)

	if Input.is_action_just_pressed("quit_game"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().quit()

	if Input.is_action_just_released("reload_scene"):
		get_tree().reload_current_scene()

	if Input.is_action_just_released("fullscreen_toggle"):
		OS.window_fullscreen = !OS.window_fullscreen
		if !OS.window_fullscreen:
			OS.window_maximized = true

	if Input.is_action_just_released("toggle_help"):
		$ControlsUI.visible = !$ControlsUI.visible

	if Input.is_action_just_pressed("mouse_toggle"):
		if mouse_captured:
			mouse_captured = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			mouse_captured = true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if Input.is_action_just_released("fps"):
		if !FPSToggled:
			FPSToggled = true
			$FPS.visible = true
		else:
			FPSToggled = false
			$FPS.visible = false
