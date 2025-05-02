extends Node2D
@onready var fuel_bar: ProgressBar = $CanvasLayer/VBoxContainer/MarginContainer/HBoxContainer/FuelBar

# Speed at which the camera/player moves forward (pixels per second)
var speed: float = 200.0
var player: Node2D
var camera: Camera2D

func _ready() -> void:
	# Assume the player and camera are children of this node
	player = $Player
	camera = $Camera2D
	fuel_bar.value = FuelStore.fuelAmount

func _process(delta: float) -> void:
	var movement = Vector2(speed * delta, 0)
	player.position += movement
	camera.position += movement
	FuelStore.add_fuel(-10 *delta)
	fuel_bar.value = FuelStore.fuelAmount
	


func _on_death_zone_body_entered(body: Node2D) -> void:
	if body == player:
		get_tree().paused = true

		var death_scene = preload("res://scenes/DeathScreen.tscn").instantiate()

		add_child(death_scene)
