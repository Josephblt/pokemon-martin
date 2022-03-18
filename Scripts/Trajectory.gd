extends ImmediateGeometry

const FORCE = 5.0
const MASS = 1.0
const TIME_STEP = 1.0 / 60.0

var _aiming = false
var _trajectory_direction = Vector3.ZERO
var _trajectory_points = []
var num_of_points = 30
var vert_segments = 2
var width = 0.05

onready var _pokeball = get_node("../Poke Ball")
onready var _kinematic = get_node("Kinematic")

func _ready():
	pass


# warning-ignore:unused_argument
func _process(delta):
	clear()
	begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	add_vertex(Vector3(0, 0, 0))
	add_vertex(Vector3(1, 1, 0))
	add_vertex(Vector3(1, 0, 0))
	end()


func _predict_trajectory():
	_kinematic.set_global_transform(_pokeball.global_transform)
	_trajectory_points.clear()
#	_trajectory_points.append(_kinematic.global_transform.origin)
	
#	if _trajectory_direction == Vector3.ZERO:
#		return
	
#	var velocity = _kinematic.global_transform.basis.xform(_trajectory_direction) * FORCE / MASS;
	
	_trajectory_points.append(to_global(Vector3(0, 1 , 0)))
	_trajectory_points.append(to_global(Vector3(0, 1 , 1)))
	_trajectory_points.append(to_global(Vector3(0, 1 , 2)))
	_trajectory_points.append(to_global(Vector3(0, 1 , 3)))
	
	
	
#	for i in num_of_points:
##		velocity += Vector3.DOWN * 9.8 * TIME_STEP
##		_kinematic.move_and_collide(velocity * TIME_STEP)
#		_trajectory_points.append()


func _draw_trajectory():
	begin(Mesh.PRIMITIVE_TRIANGLES)
	var local_points = []
	for p in _trajectory_points:
		local_points.append(p - global_transform.origin)
	var last_p = Vector3()
	var verts = []
	var ind = 0
	for p in local_points:
		var y_vec = (last_p - p).normalized()
		var x_vec = y_vec.cross(y_vec.rotated(Vector3(1, 0, 0), 0.3))
		if ind != len(local_points) - 1:
			var seg_verts = []
			for i in range(vert_segments):
				var t_width = clamp((width - ind * (width / num_of_points)), 0.01, width)
				seg_verts.append(p + t_width * x_vec.rotated(y_vec, i * 2 * PI / vert_segments).normalized())
			verts.append(seg_verts)
		last_p = p
		ind += 1
	
	for j in range(len(verts) - 1):
		var cur = verts[j]
		var nxt = verts[j + 1]
		for i in range(vert_segments):
			var nxt_i = (i + 1) % vert_segments
			
			var plane1 = Plane(cur[i], cur[nxt_i], nxt[i])
			set_normal(plane1.normal)
			add_vertex(cur[i])
			add_vertex(cur[nxt_i])
			add_vertex(nxt[i])
			
			var plane2 = Plane(cur[nxt_i], nxt[nxt_i], nxt[i])
			set_normal(plane2.normal)
			add_vertex(cur[nxt_i])
			add_vertex(nxt[nxt_i])
			add_vertex(nxt[i])
	end()


func _on_aiming_started():
	_aiming = true
	_trajectory_direction = Vector3.ZERO
#	_trajectory_points.clear()


func _on_aiming_finished():
	_aiming = false
	_trajectory_direction = Vector3.ZERO
#	_trajectory_points.clear()


func _on_aim_changed(direction):
	if _aiming:
		_trajectory_direction = direction
