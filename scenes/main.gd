extends Node2D

@onready var fuel_bar: ProgressBar = $CanvasLayer/VBoxContainer/MarginContainer/HBoxContainer/FuelBar
@onready var spawn_timer: Timer = $FuelSpawnTimer
@onready var meter_score: Label = $CanvasLayer/VBoxContainer/MarginContainer/HBoxContainer/MarginContainer/MeterScore

var speed: float = 200.0
var player: Node2D
var camera: Camera2D

var gericazn_scene = preload("res://scenes/gerican.tscn")

func _ready() -> void:
	player = $Player
	camera = $Camera2D
	fuel_bar.value = FuelStore.fuelAmount

	randomize()
	spawn_timer.wait_time = randf_range(1.0, 2.0)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

func _process(delta: float) -> void:
	var movement = Vector2(speed * delta, 0)
	player.position += movement
	camera.position += movement
	FuelStore.add_fuel(-5 * delta)
	fuel_bar.value = FuelStore.fuelAmount

	# Update the meter label
	var meters:int = round(player.position.x/100)
	meter_score.text = str(meters) + " m"

func _on_death_zone_body_entered(body: Node2D) -> void:
	if body == player:
		get_tree().paused = true
		var death_scene = preload("res://scenes/DeathScreen.tscn").instantiate()
		add_child(death_scene)

func _on_spawn_timer_timeout() -> void:
	var instance = gericazn_scene.instantiate()

	# Get the screen size
	var screen_size = get_viewport().get_visible_rect().size
	var camera_pos = camera.global_position 

	# Spawn just outside the right edge of the screen
	var spawn_x = camera_pos.x + screen_size.x + randf_range(50, 200)

	# Y can be anywhere within the vertical screen area
	var spawn_y = camera_pos.y + randf_range(15, screen_size.y-(600*0.2))
	
	

	instance.position = Vector2(spawn_x, spawn_y)
	add_child(instance)

	# Set a new random time for the next spawn
	spawn_timer.wait_time = randf_range(4.0, 9.0)
	spawn_timer.start()
