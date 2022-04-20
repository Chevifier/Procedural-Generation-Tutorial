extends KinematicBody

export var speed = 10;
export var acceleration = 9
export var gravity = -9.18
export var jump_velocity = 4

export var ROTATION_X_MIN = -80
export var ROTATION_X_MAX = 80
var direction = Vector3()
var velocity = Vector3()
var y_velocity = Vector3()
var mouse_input = Vector2()
var rotation_speed = 20.0
#attach camera node to player
onready var camera_h = $cam_h
onready var camera_v = $cam_h/cam_v
onready var camera = $cam_h/cam_v/Camera
onready var birds_eye_cam = get_parent().get_node("Camera")
onready var interact_ray = $cam_h/cam_v/Camera/interact as RayCast
var start_point = Vector3()
var free_fly = false
var free_fly_timer = 1
var snap = Vector3(0,-1,0)

func _ready():
	Data.connect("get_player_position",self,"update_position_data")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	start_point = global_transform.origin

func _physics_process(delta):
	snap = Vector3(0,-1,0)
	direction = Vector3()
	var input = Input.get_vector("left","right","down","up")
	direction += input.x * camera_h.global_transform.basis.x
	direction -= input.y * camera_h.global_transform.basis.z
	if Input.is_action_just_pressed("left_mouse"):
		$cam_h/cam_v/AnimationPlayer.play("swing")
		var object = interact_ray.get_collider();
		if object == null:
			return
		if object.has_method("interact"):
			object.interact()
		else:
			print("Object found but no interaction implemented")
			
		
	if Input.is_action_just_pressed("right_mouse"):
		if camera.current == true:
			birds_eye_cam.current = true
			camera.current = false
		else:
			camera.current = true
			birds_eye_cam.current = false
		
	if is_on_floor():
		y_velocity.y = -0.01
	else:
		y_velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			snap = Vector3.ZERO
			y_velocity.y = jump_velocity
	#control view
	camera_v.rotation_degrees.x -= mouse_input.y* rotation_speed * delta
	#clamp view on x
	camera_v.rotation_degrees.x = clamp(camera_v.rotation_degrees.x,ROTATION_X_MIN,ROTATION_X_MAX)
	#rotate player on y
	camera_h.rotation_degrees.y -= mouse_input.x * rotation_speed * delta
	#reset mouse input
	mouse_input = Vector2()
	#slowly go to max speed
	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, acceleration*delta)
	#add velocity to movement
	velocity = move_and_slide(velocity + y_velocity,Vector3.UP)
	#reset if fall off world
	if global_transform.origin.y < -100:
		global_transform.origin = start_point
		y_velocity.y = 0
			
func _input(event):
	if event is InputEventMouseMotion:
		mouse_input = event.relative
		
func update_position_data():
	Data.player_stats["position"] = global_transform.origin
	Data.player_stats["rotation"] = camera_h.rotation_degrees
	
	
	
