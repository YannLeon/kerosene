extends Node2D

@onready var fuel_bar: ProgressBar = $HUD/VBoxContainer/MarginContainer/HBoxContainer/FuelBar
@onready var meter_score: Label = $HUD/VBoxContainer/MarginContainer/HBoxContainer/MarginContainer/MeterScore
@onready var player: Node2D = $Player
@onready var camera: Camera2D = $Camera2D
@onready var ennemy_spawner: Node2D = %EnnemySpawner

var speed: float = 200.0
const party_acceleration: float = 2.00  # Tune this to balance difficulty

func _ready() -> void:
	fuel_bar.value = FuelStore.fuelAmount
	randomize()

func _process(delta: float) -> void:
	var meters: int = round(player.position.x / 100)

	# 💨 Increase speed with distance
	speed = max(200.0 + meters * party_acceleration,500)

	# 🧠 Inform the spawner to speed up enemy rate
	if ennemy_spawner.has_method("set_spawn_rate_scale"):
		ennemy_spawner.set_spawn_rate_scale(1.0 + max(meters * party_acceleration,800) * 0.01)

	# 🎮 Move player and camera
	var movement = Vector2(speed * delta, 0)
	player.position += movement
	camera.position += movement

	# 🔋 Fuel logic
	FuelStore.add_fuel(-5 * delta)
	fuel_bar.value = FuelStore.fuelAmount

	# 📏 Update score display
	meter_score.text = str(meters) + " m"

func _on_death_zone_body_entered(body: Node2D) -> void:
	if body == player:
		get_tree().paused = true
		var death_scene = preload("res://scenes/DeathScreen.tscn").instantiate()
		add_child(death_scene)
