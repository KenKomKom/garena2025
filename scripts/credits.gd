extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var p1_temp = GameManager.get_leftp1() and GameManager.get_rightp1()
	if p1_temp:
		GameManager.reset_p1()
		GameManager.play_audio("res://audio/buttons-67224.ogg")
		get_parent().opening_credits = false
		hide()
