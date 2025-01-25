extends Node2D

var p1_entered = false
var p2_entered = false

var player1_triggerer : Player
var player2_triggerer : Player
var can_trigger = true

const SPEED = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.connect("lights_switch",lights_switch)
	$Sprite2D.rotation_degrees = randf_range(0,360)
	$Sprite2D.scale = Vector2(randf_range(1,1.2),randf_range(1,1.2))
	
	
	GameManager.emit_signal("add_air_depletion",-1)
	GameManager.emit_signal("add_pressure_value",2)

func lights_switch(status):
	can_trigger = status

func _process(delta):
	if (p1_entered and not player1_triggerer.is_tanky) or (p2_entered and not player2_triggerer.is_tanky) and can_trigger:
		$ProgressBar.value+=delta*SPEED
	else:
		$ProgressBar.value=0
	if $ProgressBar.value == 100:
		$ProgressBar.value=0
		GameManager.emit_signal("add_air_depletion",1)
		GameManager.emit_signal("add_pressure_value",-2)
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
