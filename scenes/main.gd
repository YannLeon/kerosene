extends Node2D

# Speed at which the camera/player moves forward (pixels per second)
var speed: float = 200.0
var player: Node2D
var camera: Camera2D

func _ready() -> void:
	# Assume the player and camera are children of this node
	player = $Player
	camera = $Camera2D

func _process(delta: float) -> void:
	var movement = Vector2(speed * delta, 0)
	player.position += movement
	camera.position += movement


func _on_death_zone_body_entered(body: Node2D) -> void:
	if body == player:
		get_tree().paused = true

		var death_scene = preload("res://scenes/DeathScreen.tscn").instantiate()

		add_child(death_scene)
