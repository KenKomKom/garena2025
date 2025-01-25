extends Area2D

var p1_entered = false
var p2_entered = false

var player1_triggerer : Player
var player2_triggerer : Player

var is_minigaming = false
var hits = 0
var done = false
var status = false
var can_trigger = true

@onready var button_mash_bar = %ProgressBar
@export var target_hits:=15

func _ready():
	GameManager.connect("lights_switch",lights_switch)
	$Timer.wait_time = randi_range(12,40) - GameManager.zone_now
	$Timer.start()
	button_mash_bar.max_value = target_hits
	%ProgressBar.visible = false

func _process(delta):
	var p1_temp = GameManager.get_leftp1() and GameManager.get_rightp1()
	var p2_temp = GameManager.get_leftp2() and GameManager.get_rightp2()
	if (p1_entered and p1_temp) or (p2_entered and p2_temp) and can_trigger:
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
			#GameManager.play_audio("res://audio/wheel-spin-on-gravel-106641.ogg", 1, -30)
			hits+=1
			button_mash_bar.value=lerp(button_mash_bar.value,hits/1.0,0.5)
			$valve.rotation_degrees = lerp($valve.rotation_degrees, $valve.rotation_degrees +10,0.5)
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
				GameManager.play_audio("res://audio/Whoosh Star.mp3",1,0)

func _on_body_entered(body):
	if body is Player:
		if body.player_number==2:
			p2_entered = true
			player2_triggerer = body
			if player2_triggerer.is_tanky and can_trigger:
				%p2_control.visible = true
		elif body.player_number==1:
			player1_triggerer = body
			p1_entered = true
			if player1_triggerer.is_tanky and can_trigger:
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

func set_status(boolean):	
	if boolean:
		if not status:
			GameManager.emit_signal("add_air_depletion",3)
		status = boolean
		$Timer.wait_time = randi_range(10,40) - (GameManager.zone_now*2)
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
		$valve.rotation_degrees = lerp($valve.rotation_degrees, $valve.rotation_degrees - 10,0.5)
		$minus_timer.start()

func lights_switch(status):
	can_trigger = status
