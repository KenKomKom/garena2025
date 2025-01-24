extends Node2D

@export var next_floor : Node2D
@export var SPEED = 60

var counter_triggered = false
var player_triggerer : Player

var can_move_p1 = true
var can_move_p2 = true

func _process(delta):
	if counter_triggered and ((player_triggerer.player_number==2 and can_move_p2) or\
	(player_triggerer.player_number==1 and can_move_p1)):
		$ProgressBar.value+=delta*SPEED
	else:
		$ProgressBar.value=0
	if $ProgressBar.value == 100:
		$ProgressBar.value=0
		if player_triggerer.player_number==2:
			next_floor.can_move_p2 = false
		elif player_triggerer.player_number==1:
			next_floor.can_move_p1 = false
		$ProgressBar.visible = false
		

func _on_area_2d_body_entered(body):
	if body is Player :
		if (can_move_p1 or can_move_p2):
			$ProgressBar.visible = true
		if not player_triggerer:
			player_triggerer = body
			counter_triggered = true

func _on_area_2d_body_exited(body):
	if body is Player:
		if player_triggerer:
			print(body)
			$ProgressBar.visible = false
			if player_triggerer.player_number==2:
				can_move_p2 = true
			elif player_triggerer.player_number==1:
				can_move_p1 = true
			player_triggerer = null
			counter_triggered = false
