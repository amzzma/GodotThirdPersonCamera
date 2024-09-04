extends SpringArm3D


# Spring Length: The distance between this SpringArm3D and its child Node(Camera3D)
# in the -Z-Axis direction.
# Margin: The margin(you can refer to the same name concept in CSS) 
# of child Node of this Node, when Collision happening.

@export var FOV_SPEED: float = 1.
@export var FOV_MIN: float = 13.
@export var FOV_MAX: float = 50.
@export var ALTER_FOV_DEGREE: float = 5.

func _ready():
	pass


func _process(delta):
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		
		if mouse_event.button_index == MOUSE_BUTTON_WHEEL_UP:
			$Camera3D.fov -= mouse_event.factor * FOV_SPEED
			
		elif mouse_event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			var temp = $Camera3D.fov + mouse_event.factor * FOV_SPEED 
			if temp <= FOV_MAX:
				$Camera3D.fov = temp
			elif $Camera3D.fov < FOV_MAX:
				$Camera3D.fov = FOV_MAX
			
		$Camera3D.fov = clamp($Camera3D.fov, FOV_MIN, FOV_MAX+ALTER_FOV_DEGREE)
		#print("滚动量: ", mouse_event.factor)
		#print("FOV:", $Camera3D.fov)
