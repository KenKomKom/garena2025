extends Node2D

var p1_entered = false
var p2_entered = false

var player1_triggerer : Player
var player2_triggerer : Player

const SPEED = 60

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.emit_signal("add_air_depletion",-1)
	GameManager.emit_signal("pressure_dir",1)

func _process(delta):
	if p1_entered or p2_entered:
		$ProgressBar.value+=delta*SPEED
	else:
		$ProgressBar.value=0
	if $ProgressBar.value == 100:
		$ProgressBar.value=0
		GameManager.emit_signal("add_air_depletion",1)
		queue_free()

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
