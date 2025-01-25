extends CanvasLayer

func _on_start_button_up():
	GameManager.play_audio("res://audio/buttons-67224.ogg")
	GameManager.next_level = "res://scenes/ship.tscn"
	get_tree().change_scene_to_file("res://scenes/loadingscreen.tscn")

func _on_credits_button_up():
	GameManager.play_audio("res://audio/buttons-67224.ogg")
	$credits2.show()
