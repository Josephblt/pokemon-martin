extends Spatial

enum ControlMode {
	BUTTON,
	GYRO,
}

export(float, -90, 90) var look_down_clamp = -70
export(float, -90, 90) var look_up_clamp = 90
export(float, 0, 100) var button_horizontal_sensitivity = 50
export(float, 0, 100) var button_vertical_sensitivity = 50
export(float, 0, 100) var gyro_horizontal_sensitivity = 50
export(float, 0, 100) var gyro_vertical_sensitivity = 50

var _current_control_mode = ControlMode.GYRO
var _button_speed = Vector2.ZERO


func _input(event):
	if _current_control_mode == ControlMode.GYRO:
		if Input.get_gyroscope() == Vector3.ZERO:
			if event is InputEventMouseMotion:
				if Input.get_mouse_button_mask() == 2:
					var mouse_x = -event.relative.x * (gyro_horizontal_sensitivity / 100.0)
					var mouse_y = -event.relative.y * (gyro_vertical_sensitivity / 100.0)
					_rotate(mouse_y, mouse_x)


func _process(delta):
	if _current_control_mode == ControlMode.GYRO:
		var gyro = Input.get_gyroscope()
		_rotate(gyro.x, gyro.y)
	
	if _current_control_mode == ControlMode.BUTTON:
		_rotate(-_button_speed.y * delta, _button_speed.x * delta)


func _rotate(x, y):
	rotation.x += deg2rad(x)
	rotation.x = clamp(rotation.x, deg2rad(look_down_clamp), deg2rad(look_up_clamp))
	rotation.y += deg2rad(y)


func _on_game_mode_activated():
	_current_control_mode = ControlMode.GYRO
	set_process_input(_current_control_mode == ControlMode.GYRO)


func _on_calibration_mode_activated():
	_current_control_mode = ControlMode.BUTTON
	set_process_input(_current_control_mode == ControlMode.GYRO)


func _on_calibration_button_down(direction):
	var angle = 45;
	var button_x = -direction.x * angle * (button_horizontal_sensitivity / 100.0)
	var button_y = -direction.y * angle * (button_vertical_sensitivity / 100.0)
	_button_speed = Vector2(button_x, button_y)
