extends Area2D

var p1_entered = false
var p2_entered = false

var player1_triggerer : Player
var player2_triggerer : Player

var nyala = true

func _ready():
	GameManager.connect("lights_switch", lights_switch)

func lights_switch(nyala):
	self.nyala = nyala
	
func _process(delta):
	var p1_temp = GameManager.get_leftp1() and GameManager.get_rightp1()
	var p2_temp = GameManager.get_leftp2() and GameManager.get_rightp2()
	if ((p1_entered and p1_temp) or (p2_entered and p2_temp)) and nyala:
		# picked up by player
		GameManager.play_audio("res://audio/metal-moving-81780.mp3", 1,-10)
		
		
		if player1_triggerer and p1_temp:
			GameManager.reset_p1()
			player1_triggerer.set_is_tanky(true)
		if player2_triggerer and p2_temp:
			GameManager.reset_p2()
			player2_triggerer.set_is_tanky(true)
			
		$AnimationPlayer.play("interact")
		
	if (p1_entered or p2_entered) and nyala:
		$Sprite2D.material = GameManager.station_outline
	else:
		$Sprite2D.material = null
	
	%p1_control.visible = nyala and p1_entered
	%p2_control.visible = nyala and p2_entered
	

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

