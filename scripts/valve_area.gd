extends Area2D

var p1_entered = false
var p2_entered = false

var player1_triggerer = null
var player2_triggerer = null

var can_take_input = true

func _process(delta):
	var p1_temp = Input.is_action_just_pressed("leftp1") and Input.is_action_just_pressed("rightp1")
	var p2_temp = Input.is_action_just_pressed("leftp2") and Input.is_action_just_pressed("rightp2")
	if can_take_input and ((p1_entered and p1_temp) or (p2_entered and p2_temp)):
		if player1_triggerer and p1_temp:
			start_minigame(1)
			can_take_input = false
		if player2_triggerer and p2_temp:
			start_minigame(2)
			can_take_input = false

func _on_body_entered(body):
	if body is Player:
		if body.player_number==2:
			p2_entered = true
			player2_triggerer = body
		elif body.player_number==1:
			player1_triggerer = body
			p1_entered = true

func _on_body_exited(body):
	if body is Player:
		if body.player_number==2:
			p2_entered = false
			player2_triggerer = null
		elif body.player_number==1:
			player1_triggerer = null
			p1_entered = false

func start_minigame(value):
	$spinny_thing.set_up(value)

func _on_spinny_thing_success():
	GameManager.emit_signal("add_pressure_value",-1)
	get_tree().create_timer(0.1).timeout
	can_take_input = true
