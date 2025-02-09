extends Node2D

var p1_entered = false
var p2_entered = false

var player1_triggerer : Player
var player2_triggerer : Player

var nyala = true

func _ready():
	GameManager.connect("stop_all", stop_all)

func stop_all():
	GameManager.emit_signal("lights_switch", false)

func _on_area_2d_body_entered(body):
	if body is Player:
		if body.player_number==2:
			p2_entered = true
			player2_triggerer = body
			if not body.is_tanky:
				%p2_control.visible = true
		elif body.player_number==1:
			player1_triggerer = body
			p1_entered = true
			if not body.is_tanky:
				%p1_control.visible = true

func _on_area_2d_body_exited(body):
	if body is Player:
		if body.player_number==2:
			p2_entered = false
			player2_triggerer = null
			%p2_control.visible = false
		elif body.player_number==1:
			player1_triggerer = null
			p1_entered = false
			%p1_control.visible = false

func _process(delta):
	var p1_temp = GameManager.get_leftp1() and GameManager.get_rightp1()
	var p2_temp = GameManager.get_leftp2() and GameManager.get_rightp2()
	if (p1_entered and p1_temp and not player1_triggerer.is_tanky) or (p2_entered and p2_temp and not player2_triggerer.is_tanky):
		if p1_temp:
			GameManager.reset_p1()
		else:
			GameManager.reset_p2()
		nyala = not nyala
		$"../Camera2D".shake()
		GameManager.play_audio("res://audio/Power Off 01.mp3")
		if not nyala:
			$AnimatedSprite2D.play("default")
		else:
			$AnimatedSprite2D.play_backwards("default")
		GameManager.emit_signal("lights_switch",nyala)
	
	if (p1_entered and not player1_triggerer.is_tanky) or (p2_entered and not player2_triggerer.is_tanky):
		$AnimatedSprite2D.material = GameManager.station_outline
	else:
		$AnimatedSprite2D.material = null
