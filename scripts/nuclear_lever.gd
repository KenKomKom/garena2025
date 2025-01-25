extends Node2D

@export var next_lever : Node2D
@export var is_leader := false

var p1_entered = false
var p2_entered = false

var player1_triggerer : Player
var player2_triggerer : Player
var is_minigaming = false

var going_to_show :int

signal button_hit()

var count = 0
var can_take_input = true
var player_idx
var can_trigger = true

var is_ready = false

var default : Vector2

func _ready():
	GameManager.connect("start_meltdown", _set_up)
	GameManager.connect("lights_switch", lights_switch)
	next_lever.connect("button_hit", _on_next_lever_button_hit)

func _set_up():
	$alert.visible = true
	if is_leader:
		var this = choose_left_right()
		var that = 1 if this==2 else 2
		self.going_to_show = this
		next_lever.going_to_show = that
		can_take_input = true
	else:
		can_take_input = false
	count=0
	player_idx = null
	$AnimatedSprite2D.play_backwards("down")

func lights_switch(status):
	can_trigger = status

func _process(delta):
	if $alert.visible:
		var p1_temp = GameManager.get_leftp1() and GameManager.get_rightp1()
		var p2_temp = GameManager.get_leftp2() and GameManager.get_rightp2()
		if (p1_entered and p1_temp) or (p2_entered and p2_temp) and can_trigger:
			if (p1_entered and not p2_entered):
				GameManager.reset_p1()
				player1_triggerer.can_move = false
			elif (not p1_entered and p2_entered):
				GameManager.reset_p2()
				player2_triggerer.can_move = false
			is_ready = true
			return
	
	if is_ready and next_lever.is_ready:
		%p2_control.visible = false
		%p1_control.visible = false
		default = $Area2D/CollisionShape2D.shape.size
		$Area2D/CollisionShape2D.shape.size.x = $Area2D/CollisionShape2D.shape.size.x+20
		is_minigaming = true
	
	if is_minigaming:
		$alert.visible = false
		var p1_left = GameManager.get_leftp1()
		var p1_right = GameManager.get_rightp1()
		
		var p2_left = GameManager.get_leftp2()
		var p2_right = GameManager.get_rightp2()
		
		var strr = ("kiri" if going_to_show==1 else "kanan")+str(player_idx)
		if can_take_input:
			get_node(strr).visible = true
		
		if can_take_input and (p1_entered and ((p1_left and going_to_show==1) or (p1_right and going_to_show==2))) or \
		(p2_entered and ((p2_left and going_to_show==1) or (p2_right and going_to_show==2))):
			if p1_entered:
				GameManager.reset_p1()
				player1_triggerer.can_move = false
			else:
				GameManager.reset_p2()
				player2_triggerer.can_move = false
			get_node(("kiri" if going_to_show==1 else "kanan")+str(player_idx)).visible = false
			emit_signal("button_hit")
			can_take_input = false
			count+=1
			if count>=5 and not is_leader:
				is_minigaming = false
				is_ready = false
				if p1_entered:
					player1_triggerer.can_move = true
				else:
					player2_triggerer.can_move = true
				GameManager.play_audio("res://audio/Whoosh Star.mp3",1,0)
				$AnimatedSprite2D.play("down")
				$Area2D/CollisionShape2D.shape.size = default

func choose_left_right():
	return randi_range(1,2)

func _on_area_2d_body_entered(body):
	if body is Player:
		if body.player_number==2 and not p1_entered:
			p2_entered = true
			player2_triggerer = body
			player_idx = 2
			if $alert.visible and not body.is_tanky:
				%p2_control.visible =true
		elif body.player_number==1 and not p2_entered:
			player1_triggerer = body
			p1_entered = true
			player_idx = 1
			if $alert.visible and not body.is_tanky:
				%p1_control.visible =true

func _on_area_2d_body_exited(body):
	if body is Player:
		if body.player_number==2:
			p2_entered = false
			player2_triggerer = null
			%p2_control.visible =false
		elif body.player_number==1:
			player1_triggerer = null
			p1_entered = false
			%p1_control.visible = false

func _on_next_lever_button_hit():
	if is_leader:
		print(is_leader, count)
		var this = choose_left_right()
		var that = 1 if this==2 else 2
		self.going_to_show = this
		next_lever.going_to_show = that
		can_take_input = true
		if count>=5:
			count=0
			if p1_entered:
				player1_triggerer.can_move = true
			else:
				player2_triggerer.can_move = true
			is_minigaming = false
			is_ready = false
			GameManager.emit_signal("meltdown_done")
			$Area2D/CollisionShape2D.shape.size = default
	else:
		can_take_input = true
