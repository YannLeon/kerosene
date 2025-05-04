extends Node

var main_scene_path := "res://scenes/Main.tscn"

func load_scene(path: String) -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(path)

func restart_main() -> void:
	FuelStore.add_fuel(100)
	load_scene(main_scene_path)
