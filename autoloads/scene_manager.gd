extends Node

const LOADING = preload("res://scenes/Loading.tscn")
const MAIN = preload("res://scenes/main.tscn")

func load_scene(path: String) -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(path)

func restart_main() -> void:
	FuelStore.add_fuel(100)

	# Load the loading screen first
	load_scene(LOADING.resource_path)

	# Wait 2 seconds, then load the main scene
	await get_tree().create_timer(1.0).timeout
	load_scene(MAIN.resource_path)
