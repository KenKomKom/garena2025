extends Node2D

var p1_entered = false
var p2_entered = false

var player_triggerer = null
@export var next_floor:Node2D

func _process(delta):
	if p1_entered and Input.is_action_just_pressed("leftp1") and Input.is_action_just_pressed("rightp1") or (p2_entered and Input.is_action_just_pressed("leftp2") and Input.is_action_just_pressed("rightp2")):
		player_triggerer.set_move_to_target(next_floor)
	
func _on_area_2d_body_entered(body):
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	pass # Replace with function body.
