extends CharacterBody3D

@onready var yaw: Node3D = $yaw
@onready var pitch: Node3D = $yaw/pitch
@onready var camera_3d: Camera3D = $"../Camera3D"
@onready var label_3d: Label3D = $Label3D

var input_dir: Vector2 = Vector2.ZERO
var motion_dir: Vector3 = Vector3.ZERO
var walk_speed: float = 10.0
var jump_speed: float = 35.0
var gravity: float = 4.8
@export var mouse_locked: bool = false
@export var near_table: bool = false
@export var switch_camera: bool = false

func _process(delta: float) -> void:
	if mouse_locked:
		if near_table:
			if Input.is_action_just_pressed("interaction"):
				switch_camera = true
				camera_3d.current = false
			if Input.is_action_just_pressed("ui_cancel"):
				switch_camera = false
				camera_3d.current = true
		label_3d.rotation.y = yaw.rotation.y

func _physics_process(delta: float) -> void:
	if mouse_locked and not switch_camera:
		input_dir = Input.get_vector("left", "right", "forward", "backward").normalized()
		motion_dir = yaw.basis * Vector3(input_dir.x, 0.0, input_dir.y) * walk_speed
		velocity.x = motion_dir.x
		velocity.z = motion_dir.z
		if not is_on_floor():
			velocity.y -= gravity
		if is_on_floor() and Input.is_action_just_pressed("jump"):
			velocity.y += jump_speed
		move_and_slide()

func _input(event: InputEvent) -> void:
	if not switch_camera and Input.is_action_just_pressed("ui_cancel") and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		mouse_locked = false
	if not switch_camera and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		mouse_locked = true
	if not switch_camera and mouse_locked and event is InputEventMouseMotion:
		yaw.rotate_y(-event.relative.x * 0.01)
		pitch.rotate_x(-event.relative.y * 0.01)
		pitch.rotation.x = clamp(pitch.rotation.x, deg_to_rad(-45), deg_to_rad(75))
