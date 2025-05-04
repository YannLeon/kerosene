extends Node2D

@export var enemy_scene: PackedScene
@export var min_spawn_time: float = 4.0
@export var max_spawn_time: float = 9.0
@export var vertical_margin: float = 15.0

@onready var spawn_timer: Timer = $SpawnTimer
var camera: Camera2D

func _ready() -> void:
	randomize()	# Automatically find the Camera2D in the scene
	camera = get_tree().get_root().get_node("Main/Camera2D") # Adjust path as needed
	if !camera:
		push_warning("Camera2D not found. Make sure the path is correct.")
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	_set_random_spawn_time()

func _on_spawn_timer_timeout() -> void: 
	if !is_instance_valid(camera):
		return

	var screen_size = get_viewport().get_visible_rect().size
	var camera_pos = camera.global_position

	var spawn_x = camera_pos.x + screen_size.x + randf_range(50, 200)
	var spawn_y = camera_pos.y + randf_range(vertical_margin, screen_size.y - (600 * 0.2))

	var instance = enemy_scene.instantiate()
	instance.position = Vector2(spawn_x, spawn_y)
	get_tree().current_scene.add_child(instance)

	_set_random_spawn_time()

func _set_random_spawn_time():
	spawn_timer.wait_time = randf_range(min_spawn_time, max_spawn_time)
	print(spawn_timer.wait_time)
	spawn_timer.start()
