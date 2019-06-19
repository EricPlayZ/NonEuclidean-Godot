extends KinematicBody

var camera_angle = 0
var mouse_sens = 0.3
var velocity = Vector3()
var direction = Vector3()

# Fly variables
var FLY_SPEED = 40
const FLY_ACCEL = 4
var isFlying : bool = false

# Walk variables
var gravity = -9.8 * 3
var MAX_SPEED = 10
const ACCEL = 10
const DEACCEL = 10

func _physics_process(delta):
	if !isFlying:
		walk(delta)
		if Input.is_action_just_pressed("FlyCheat"):
			isFlying = true
			fly(delta)
		if Input.is_action_just_pressed("sub"):
			if MAX_SPEED == 1:
				return
			MAX_SPEED -= 1
		if Input.is_action_just_pressed("add"):
			if MAX_SPEED == 40:
				return
			MAX_SPEED += 1
		if Input.is_action_just_pressed("reset_speed"):
			MAX_SPEED = 10
	else:
		fly(delta)
		if Input.is_action_just_pressed("FlyCheat"):
			isFlying = false
			walk(delta)
		if Input.is_action_just_pressed("sub"):
			if FLY_SPEED == 1:
				return
			FLY_SPEED -= 1
		if Input.is_action_just_pressed("add"):
			if FLY_SPEED == 40:
				return
			FLY_SPEED += 1
		if Input.is_action_just_pressed("reset_speed"):
			FLY_SPEED = 10

func walk(delta):
	direction = Vector3()

	var aim = $Body/Head/Camera.global_transform.basis
	if Input.is_action_pressed("ui_up"):
		direction -= aim.z
	if Input.is_action_pressed("ui_down"):
		direction += aim.z
	if Input.is_action_pressed("ui_left"):
		direction -= aim.x
	if Input.is_action_pressed("ui_right"):
		direction += aim.x

	direction = direction.normalized()
	velocity.y += gravity * delta

	var temp_velocity = velocity
	temp_velocity.y = 0

	var speed = MAX_SPEED
	var target = direction * speed
	var acceleration
	if direction.dot(temp_velocity) > 0:
		acceleration = ACCEL
	else:
		acceleration = DEACCEL

	temp_velocity = temp_velocity.linear_interpolate(target, acceleration * delta)
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.z

	velocity = move_and_slide(velocity, Vector3(0, 1, 0))

func fly(delta):
	direction = Vector3()

	var aim = $Body/Head/Camera.global_transform.basis
	if Input.is_key_pressed(KEY_W):
		direction -= aim.z
	if Input.is_key_pressed(KEY_S):
		direction += aim.z
	if Input.is_key_pressed(KEY_A):
		direction -= aim.x
	if Input.is_key_pressed(KEY_D):
		direction += aim.x

	direction = direction.normalized()
	var target = direction * FLY_SPEED
	var temp_velocity = velocity
	temp_velocity = temp_velocity.linear_interpolate(target, FLY_ACCEL * delta)
	velocity = temp_velocity

	velocity = move_and_slide(velocity)

func _input(event):
	if event is InputEventMouseMotion:
		$Body/Head.rotate_y(deg2rad(-event.relative.x * mouse_sens))

		var change = -event.relative.y * mouse_sens
		if change + camera_angle < 90 && change + camera_angle > -90:
			$Body/Head/Camera.rotate_x(deg2rad(change))
			camera_angle += change