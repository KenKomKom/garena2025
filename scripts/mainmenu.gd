extends CanvasLayer

func _on_start_button_up():
	GameManager.next_level = "res://scenes/ship.tscn"
	GameManager.play_audio("res://audio/buttons-67224.ogg")
	get_tree().change_scene_to_file("res://scenes/loadingscreen.tscn")
