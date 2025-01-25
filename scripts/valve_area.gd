extends Area2D

var p1_entered = false
var p2_entered = false

var player1_triggerer = null
var player2_triggerer = null

var can_take_input = true
var can_trigger = true

var default : Vector2

func _ready():
	GameManager.connect("lights_switch",lights_switch)
	GameManager.connect("spawn_radar", spawn_radar)
	$Sprite2D.play("default")

func lights_switch(status):
	can_trigger = status

func _process(delta):
	var p1_temp = GameManager.get_leftp1() and GameManager.get_rightp1()
	var p2_temp = GameManager.get_leftp2() and GameManager.get_rightp2()
	if can_take_input and ((p1_entered and p1_temp and not player1_triggerer.is_tanky) or\
	(p2_entered and p2_temp and not player2_triggerer.is_tanky)) and can_trigger:
		
		if player1_triggerer and p1_temp:
			GameManager.reset_p1()
			player1_triggerer.can_move = false
			start_minigame(1)
			can_take_input = false
		if player2_triggerer and p2_temp:
			GameManager.reset_p2()
			player2_triggerer.can_move = false
			start_minigame(2)
			can_take_input = false
		
	if can_take_input and ((p1_entered and not player1_triggerer.is_tanky) or\
	(p2_entered and not player2_triggerer.is_tanky)) and can_trigger:
		
		
		$Sprite2D.material = GameManager.station_outline
	else:
		$Sprite2D.material = null
		

func _on_body_entered(body):
	if body is Player:
		if body.player_number==2:
			p2_entered = true
			player2_triggerer = body
			if not body.is_tanky and can_trigger:
				%p2_control.visible = true
		elif body.player_number==1:
			player1_triggerer = body
			p1_entered = true
			if not body.is_tanky and can_trigger:
				%p1_control.visible = true

func _on_body_exited(body):
	if body is Player:
		if body.player_number==2:
			p2_entered = false
			player2_triggerer = null
			%p2_control.visible = false
		elif body.player_number==1:
			player1_triggerer = null
			p1_entered = false
			%p1_control.visible = false

func start_minigame(value):
	default = $CollisionShape2D.shape.size
	$CollisionShape2D.shape.size.x = $CollisionShape2D.shape.size.x+40
	$spinny_thing.set_up(value)

func _on_spinny_thing_success():
	GameManager.emit_signal("add_pressure_value",-2)
	GameManager.play_audio("res://audio/Whoosh Star.mp3",1,0)
	if player1_triggerer:
		player1_triggerer.can_move = true
	if player2_triggerer:
		player2_triggerer.can_move = true
	$CollisionShape2D.shape.size = default
	await get_tree().create_timer(0.1).timeout
	can_take_input = true

func spawn_radar():
	$Radar.visible = true
	await get_tree().create_timer(15).timeout
	$Radar.visible = false
	
