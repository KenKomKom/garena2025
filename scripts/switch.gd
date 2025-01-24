extends Node2D

var p1_entered = false
var p2_entered = false

var player1_triggerer : Player
var player2_triggerer : Player

var nyala = true

func _on_area_2d_body_entered(body):
	if body is Player:
		if body.player_number==2:
			p2_entered = true
			player2_triggerer = body
		elif body.player_number==1:
			player1_triggerer = body
			p1_entered = true

func _on_area_2d_body_exited(body):
	if body is Player:
		if body.player_number==2:
			p2_entered = false
			player2_triggerer = null
		elif body.player_number==1:
			player1_triggerer = null
			p1_entered = false

func _process(delta):
	var p1_temp = Input.is_action_just_pressed("leftp1") and Input.is_action_just_pressed("rightp1")
	var p2_temp = Input.is_action_just_pressed("leftp2") and Input.is_action_just_pressed("rightp2")
	if (p1_entered and p1_temp) or (p2_entered and p2_temp):
		nyala = not nyala
		GameManager.emit_signal("lights_switch",nyala)
