extends CanvasLayer
@onready var score: Label = %score


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score.text = GlobalState.final_score


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_retry_button_pressed() -> void:
	SceneManager.restart_main()
