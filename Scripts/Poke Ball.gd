extends RigidBody

signal aiming_started
signal aiming_finished
signal aim_changed (direction)

var _can_aim = false
var _can_pick = true
var _can_throw = false
var _pick_position = Vector2.ZERO
var _throw_direction = Vector3.ZERO


func _ready():
	_pick_position = translation


func _pick():
	_can_aim = true
	_can_pick = false
	_can_throw = false
	emit_signal("aiming_started")


func _retrieve():
	_can_aim = false
	_can_pick = true
	_can_throw = false
	set_sleeping(true);
	set_as_toplevel(false)
	rotation = Vector3.ZERO
	translation = _pick_position


func _drop():
	_can_aim = false
	_can_pick = true
	_can_throw = false
	emit_signal("aiming_finished")


func _throw():
	_can_aim = false
	_can_pick = false
	_can_throw = false
	set_sleeping(false);
	set_as_toplevel(true)
	apply_central_impulse(transform.basis.xform(_throw_direction * 5.0))
	emit_signal("aiming_finished")


func _freeze():
	set_sleeping(true);


func _aim():
	var aim_center = get_viewport().get_camera().unproject_position(global_transform.origin)
	var aim_target = get_viewport().get_mouse_position()
	var direction = aim_target - aim_center
	var strength = direction.length()
	direction = direction.normalized()
	if direction.y < 0:
		_can_throw = false
		emit_signal("aiming_finished")
	else:
		_can_throw = true
		emit_signal("aiming_started")
	_throw_direction = Vector3(-direction.x, 0.7, -direction.y) / 100.0 * strength
	emit_signal("aim_changed", _throw_direction)


# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				if _can_pick:
					_pick()
				else:
					_retrieve()
			else:
				if _can_throw:
					_throw()
				else:
					_drop()
			
	if event is InputEventMouseMotion:
		if _can_aim:
			_aim()


# warning-ignore:unused_argument
func _on_body_entered(body):
	pass
