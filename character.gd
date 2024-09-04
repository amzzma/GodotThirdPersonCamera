extends Node3D

# This is an example that directly.You should import your scene inheriting from model.And 
# you can refer to this script.


enum States {IDLE, RUNNING, ATTACK}
var state: States = States.IDLE


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationTree.active = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print($AnimationPlayer.current_animation)
	#set_state()
	pass


func _input(event: InputEvent) -> void:
	if (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") \
	or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down")) \
	and $AnimationPlayer.current_animation != "your animation":
		state = States.RUNNING
		
	if event is InputEventMouseButton and event.button_mask & 1:
		state = States.ATTACK


func _physics_process(delta: float) -> void: 
	#print("state:", state)
	pass


#func set_state():
	#if $AnimationPlayer.current_animation != "your animation":
		#if state == States.ATTACK:
			#$AnimationPlayer.play("your animation")
			#state = States.IDLE
		#elif state == States.RUNNING:
			#if $AnimationPlayer.current_animation != "your animation":
				#$AnimationPlayer.play("your animation")
		#elif state == States.IDLE:
			#$AnimationPlayer.play("your animation")
