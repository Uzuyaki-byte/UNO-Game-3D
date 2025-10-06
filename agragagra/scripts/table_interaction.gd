extends Area3D

@onready var player: CharacterBody3D = $"../player"
@onready var label: Label3D = player.get_node("Label3D")
@onready var camera_3d: Camera3D = $"../Camera3D"

func _on_body_entered(body: Node3D) -> void:
	label.show()
	player.near_table = true


func _on_body_exited(body: Node3D) -> void:
	label.hide()
	player.near_table = false

func _process(delta: float) -> void:
	if player.switch_camera:
		camera_3d.current = true
	else:
		camera_3d.current = false
