extends Node2D

@onready var fuel_bar: ProgressBar = $HUD/VBoxContainer/MarginContainer/HBoxContainer/FuelBar
@onready var meter_score: Label = $HUD/VBoxContainer/MarginContainer/HBoxContainer/MarginContainer/MeterScore
@onready var player: Node2D = $Player
@onready var camera: Camera2D = $Camera2D
@onready var ennemy_spawner: Node2D = %EnnemySpawner
@onready var fuel_spawner: Node2D = %FuelSpawner
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var press_to_play_label: Label = %PressToPlay

var speed: float = 200.0
const party_acceleration: float = 2.0

var game_started: bool = false

func _ready() -> void:
	fuel_bar.value = FuelStore.fuelAmount
	randomize()
	press_to_play_label.visible = true
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if not game_started and event.is_action_pressed("action"):
		game_started = true
		player.game_started = true
		press_to_play_label.visible = false
		ennemy_spawner.start()
		fuel_spawner.start()
		audio_stream_player.play(0.7)

func _process(delta: float) -> void:
	var movement = Vector2(speed * delta, 0)
	player.position += movement
	camera.position += movement

	if game_started:
		var meters: int = round(player.position.x / 100)

		# 💨 Increase speed with distance
		speed = max(200.0 + meters *  party_acceleration , 500)

		# 🧠 Enemy spawner logic
		if ennemy_spawner.has_method("set_spawn_rate_scale"):
			ennemy_spawner.set_spawn_rate_scale(1.0 + max(meters * party_acceleration, 800) * 0.01)

		# 🔋 Fuel logic
		FuelStore.add_fuel(-5 * delta)
		fuel_bar.value = FuelStore.fuelAmount

		# 📏 Update score
		meter_score.text = str(meters) + " m"

func _on_death_zone_body_entered(body: Node2D) -> void:
	if body == player:
		get_tree().paused = true
		var death_scene = preload("res://scenes/DeathScreen.tscn").instantiate()
		add_child(death_scene)
