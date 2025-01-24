extends Area2D

var p1_entered = false
var p2_entered = false

var player1_triggerer : Player
var player2_triggerer : Player

var is_minigaming = false
var hits = 0
var done = false
var status = false
@onready var button_mash_bar = %ProgressBar
@export var target_hits:=7

func _ready():
	$Timer.wait_time = randi_range(5,10) - GameManager.zone_now
	$Timer.start()
	button_mash_bar.max_value = target_hits
	%ProgressBar.visible = false

func _process(delta):
	var p1_temp = Input.is_action_just_pressed("leftp1") and Input.is_action_just_pressed("rightp1")
	var p2_temp = Input.is_action_just_pressed("leftp2") and Input.is_action_just_pressed("rightp2")
	if (p1_entered and p1_temp) or \
	(p2_entered and p2_temp):
		if player1_triggerer and player1_triggerer.is_tanky and p1_temp:
			player1_triggerer.set_is_tanky(false)
			player1_triggerer.can_move = false
			start_minigame()
		if player2_triggerer and player2_triggerer.is_tanky and p2_temp:
			player2_triggerer.set_is_tanky(false)
			player2_triggerer.can_move = false
			start_minigame()
	if is_minigaming:
		if p1_entered:
			%p1_control.visible = true
		if p2_entered:
			%p2_control.visible = true
		if (p1_entered and p1_temp) or (p2_entered and p2_temp):
			hits+=1
			button_mash_bar.value=lerp(button_mash_bar.value,hits/1.0,0.5)
			if hits==target_hits:
				button_mash_bar.value=target_hits
				is_minigaming=false
				$"panah animasi".visible = false
				if player1_triggerer:
					player1_triggerer.can_move = true
					set_status(true)
				if player2_triggerer:
					player2_triggerer.can_move = true
					set_status(true)
				%ProgressBar.visible = false
				if p1_entered:
					%p1_control.visible = false
				if p2_entered:
					%p2_control.visible = false

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

func set_status(boolean):	
	if boolean:
		if not status:
			GameManager.emit_signal("add_air_depletion",3)
		status = boolean
		$Timer.wait_time = randi_range(30,40) - (GameManager.zone_now*2)
		$Timer.start()
		return
	else:
		if not status:
			GameManager.emit_signal("add_air_depletion",-3)
		status = boolean
		# TODO: masukin ALLERT sprite
		$Timer/allert.visible = true
		%ProgressBar.visible = true
		%ProgressBar.value = 0

func _on_timer_timeout():
	set_status(false)
	$Timer.stop()

func start_minigame():
	is_minigaming = true
	hits = 0
	%ProgressBar.visible = true
	$"panah animasi".visible = true

func _on_minus_timer_timeout():
	if is_minigaming:
		hits=max(0,hits-1)
		button_mash_bar.value=lerp(button_mash_bar.value,hits/1.0,0.5)
		$minus_timer.start()
