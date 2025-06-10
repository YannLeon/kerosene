extends Node2D

@export var enemy_scene: PackedScene
@export var min_spawn_time: float = 4.0
@export var max_spawn_time: float = 9.0
@export var vertical_margin: float = 15.0
var spawn_rate_scale := 1.0

@onready var spawn_timer: Timer = $SpawnTimer
var camera: Camera2D

func start() -> void:
	_set_random_spawn_time()

func _ready() -> void:
	randomize()
	camera = get_tree().get_root().get_node("Main/Camera2D") # Adjust path if needed
	if !camera:
		push_warning("Camera2D not found. Make sure the path is correct.")
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

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

func set_spawn_rate_scale(scale: float) -> void:
	spawn_rate_scale = clamp(scale, 0.5, 3.0)  # Prevent too fast or slow

func _set_random_spawn_time():
	var scaled_min = min_spawn_time / spawn_rate_scale
	var scaled_max = max_spawn_time / spawn_rate_scale
	spawn_timer.wait_time = randf_range(scaled_min, scaled_max)
	spawn_timer.start()
