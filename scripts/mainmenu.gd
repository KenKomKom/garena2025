extends CanvasLayer

var opening_credits = false:
	set(val):
		opening_credits = val
		if not val:
			proc = 0.3
var proc = 0.3

func _on_start_button_up():
	#$start.texture_normal = load("res://icon.svg")
	GameManager.play_audio("res://audio/buttons-67224.ogg")
	await get_tree().create_timer(0.3).timeout
	GameManager.next_level = "res://scenes/ship.tscn"
	get_tree().change_scene_to_file("res://scenes/loadingscreen.tscn")

func _on_credits_button_up():
	opening_credits = true
	#$start.texture_normal = load("res://icon.svg")
	GameManager.play_audio("res://audio/buttons-67224.ogg")
	$credits2.show()

func _process(delta):
	proc -=delta
	if not opening_credits and proc<0:
		var a = GameManager.get_leftp1()
		var d = GameManager.get_rightp1()
		if a:
			_on_start_button_up()
		elif d:
			_on_credits_button_up()
