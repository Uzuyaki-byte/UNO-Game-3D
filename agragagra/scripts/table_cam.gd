extends Camera3D

@onready var player: CharacterBody3D = $"../player"

var yaw := 0.0   # Around Y (left/right)
var pitch := 0.0 # Around X (up/down)
var sensitivity := 0.01

func _ready():
	# Get current camera orientation as base (in radians)
	var euler = rotation
	pitch = euler.x  # -70.9 deg ≈ -1.237 rad
	yaw = euler.y    # 90 deg ≈ 1.571 rad

func _input(event: InputEvent) -> void:
	if player.switch_camera:
		if event is InputEventMouseMotion:
			yaw -= event.relative.x * sensitivity
			pitch -= event.relative.y * sensitivity
			pitch = clamp(pitch, deg_to_rad(-89), deg_to_rad(89))  # Prevent flipping

			# Apply rotation directly (in radians)
			rotation = Vector3(pitch, yaw, 0)
	else:
		# Snap back to original static view
		rotation_degrees = Vector3(-58.7, 90.0, 0.0)
