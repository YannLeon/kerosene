extends Node2D

@onready var fuel_bar: ProgressBar = $HUD/VBoxContainer/MarginContainer/HBoxContainer/FuelBar
@onready var meter_score: Label = $HUD/VBoxContainer/MarginContainer/HBoxContainer/MarginContainer/MeterScore
@onready var player: Node2D = $Player
@onready var camera: Camera2D = $Camera2D

var speed: float = 200.0

func _ready() -> void:
	fuel_bar.value = FuelStore.fuelAmount
	randomize()

func _process(delta: float) -> void:
	var movement = Vector2(speed * delta, 0)
	player.position += movement
	camera.position += movement

	FuelStore.add_fuel(-5 * delta)
	fuel_bar.value = FuelStore.fuelAmount

	var meters: int = round(player.position.x / 100)
	meter_score.text = str(meters) + " m"

func _on_death_zone_body_entered(body: Node2D) -> void:
	if body == player:
		get_tree().paused = true
		var death_scene = preload("res://scenes/DeathScreen.tscn").instantiate()
		add_child(death_scene)
