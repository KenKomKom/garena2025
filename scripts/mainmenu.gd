extends CanvasLayer

func _on_start_button_up():
	GameManager.next_level = "res://scenes/ship.tscn"
	get_tree().change_scene_to_file("res://scenes/loadingscreen.tscn")
