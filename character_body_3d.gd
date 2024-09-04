extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var alter_fov_flag: bool = false
var delta_fov = 0.
@export var CHARACTER_ROTATING_SPEED = 0.8


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := -(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var temp_direction = direction
	
	if direction:
		direction = transform_direction(direction)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		# You can choose whether to interpolate, instead adding new func to make it
		adjust_direction(temp_direction)
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	check_idle(temp_direction)
	alter_fov(temp_direction)


func adjust_direction(temp_direction):
	var camera_global_rotation_y = $CameraBase/CameraPivot/SpringArm3D/Camera3D.global_transform.basis.get_euler().y
	var delta_theta = camera_global_rotation_y - global_transform.basis.get_euler().y
	delta_theta = fmod(delta_theta, 2*PI)
	#print("delta:", delta_theta)
	
	# It doesn't add PI because the angle of vec2angle func return is more PI radians
	# than physical rotation by X-Axis in practice
	$"Character".rotation.y = delta_theta + vec2angle(-temp_direction)


func transform_direction(direction):
	var cha_basis_matrix: Basis = $"Character".get_transform().basis
	#var cha_basis_matrix: Basis = $"Character".get_transform().basis
	var ca_basis_matrix: Basis = $CameraBase/CameraPivot/SpringArm3D/Camera3D.get_camera_transform().basis
	
	# Transforms the velocity by Camera Object Basis Matrix
	# cha_basis_matrix is alternative but there are some difference about move direction
	return ca_basis_matrix * -direction


func vec2angle(vec: Vector3):
	var temp_vec = Vector2(vec.x, vec.z)
	var cos_theta = temp_vec.y/temp_vec.length()
	#print("vec:", vec)
	var ret = acos(cos_theta)
	if vec.x != 0:  # Using for analysing the direction of rotation
		ret = ret * abs(temp_vec.x)/temp_vec.x
	#print("arccos:", ret)
	return ret


func check_idle(temp_direction):
	# 混合动画不会用，只能写个排它方法的
	if temp_direction == Vector3.ZERO and $"Character".state != 2:
		$"Character".state = 0


func alter_fov(temp_direction):
	var fov = $CameraBase/CameraPivot/SpringArm3D/Camera3D.fov
	var max_fov = $CameraBase/CameraPivot/SpringArm3D.FOV_MAX
	# the max degree of adding fov. 
	var alter_degree:float = $CameraBase/CameraPivot/SpringArm3D.ALTER_FOV_DEGREE
	# The weight should be change to proper formula.
	# shift: (max_fov-sqrt(fov))/600 + 0.001
	var w_u = (max_fov-sqrt(fov))/4.8e3 + 0.001  # The weight of upscale of adding fov
	var w_d = (alter_degree-sqrt(delta_fov))/200 + 0.001
	#print("Fov: ", $CameraBase/CameraPivot/SpringArm3D/Camera3D.fov)
	
	if velocity != Vector3.ZERO:
		if temp_direction.z > 0:
			alter_fov_flag = 1
			var temp = lerp(fov, max_fov+alter_degree, w_u)
			delta_fov += temp - fov
			$CameraBase/CameraPivot/SpringArm3D/Camera3D.fov = temp
			
	elif velocity == Vector3.ZERO and alter_fov_flag and delta_fov > 0:
		delta_fov = clamp(delta_fov, 0., alter_degree)
		var temp = lerp(1e-3, delta_fov, w_d)
		$CameraBase/CameraPivot/SpringArm3D/Camera3D.fov -= temp
		delta_fov -= temp
		#print("delta_fov:", delta_fov)
		alter_fov_flag = delta_fov > 1e-3
	
		if not alter_fov_flag:
			$CameraBase/CameraPivot/SpringArm3D/Camera3D.fov = clamp(fov, 0, max_fov)
