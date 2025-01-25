extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var p1_temp = GameManager.get_leftp1() and GameManager.get_rightp1()
	if p1_temp:
		hide()
