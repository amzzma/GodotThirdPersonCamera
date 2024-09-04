extends Node3D

# You should alter this node Position.y to a fitting extent


@export var HORIZEN_ROTATING_SPEED = 0.001
@export var VERTICAL_ROTATING_SPEED = 0.001
@export var HORIZEN_MIN = -PI/2.8
@export var HORIZEN_MAX = PI/2.8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _input(event):
	if event is InputEventMouseMotion: # and !(event.button_mask & 1):
		rotation.y -= event.relative.x * HORIZEN_ROTATING_SPEED
		rotation.x -= event.relative.y * VERTICAL_ROTATING_SPEED
		rotation.x = clamp(rotation.x, HORIZEN_MIN, HORIZEN_MAX)
