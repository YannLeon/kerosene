extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var collected: bool = false

func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_finished)

func _process(delta: float) -> void:
	pass

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if collected:
		return
	collected = true
	animation_player.play("collect")
	FuelStore.add_fuel(50)

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "collect":
		queue_free()
