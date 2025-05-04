extends Node2D

signal ennemyhit

@export var speed: float = 100.0  # Pixels per second to the left

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	position.x -= speed * delta  # Move left toward the player

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GlobalEvents.emit_signal("ennemyhit", body)
