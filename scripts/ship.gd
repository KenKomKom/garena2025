extends Node2D

var oxygen_level = 100
var pressure_level = 0

var live_tank :=3

var bocor_preload = preload("res://scenes/bocor.tscn")
var can_bocor = false
var can_meltdown = false
var can_attacked_fish = false

var status_lampu = false

@onready var list_of_available_bocor_spot := $Node2D

func _ready():
	GameManager.connect("zone_reached", bocor_mulai)
	GameManager.connect("meltdown_done", meltdown_done)
	GameManager.connect("lights_switch", lights_switch)
	
	bocor_mulai(GameManager.ZONE.BATHYPELAGIC) # TODO: HAPUS, DEBUGGING PURPOSES

func bocor_mulai(zone):
	match zone:
		GameManager.ZONE.EPIPELAGIC:
			var p = %manual as Manual
			p.add_text(p.EVENTS.TANK)
			p.add_text(p.EVENTS.MONITOR)
			p.animate_in()
		GameManager.ZONE.MESOPELAGIC:
			can_bocor = true
			$bocor_timer.start()
			var p = %manual as Manual
			p.add_text(p.EVENTS.LEAKS)
			p.add_text(p.EVENTS.PREDATOR_FISH)
			p.animate_in()
		GameManager.ZONE.BATHYPELAGIC:
			can_meltdown = true
			can_attacked_fish = true
			$meltdown_timer.start()
			var p = %manual as Manual
			p.add_text(p.EVENTS.NUCLEAR_MELTDOWN)
			p.animate_in()

func instantiate_bocor():
	var temp = bocor_preload.instantiate()
	var marker = list_of_available_bocor_spot.get_child(randi_range(0,list_of_available_bocor_spot.get_child_count()-1))
	if marker.get_child_count()>1:
		return
	marker.add_child(temp)
	temp.global_position = marker.global_position

func _on_bocor_timer_timeout():
	if can_bocor:
		for i in range(randi_range(2,5)):
			instantiate_bocor()
		$bocor_timer.wait_time = randi_range(20,30)

func _on_meltdown_timer_timeout():
	if can_meltdown:
		GameManager.emit_signal("start_meltdown")
		print("meltdown")
		$meltdown_timer.wait_time = 3 #randi_range(30,40)

func _on_menltdown_kill_timeout():
	GameManager.emit_signal("gameover", GameManager.DEATH_REASON.MELTDOWN)

func meltdown_done():
	$menltdown_kill.stop()
	$meltdown_timer.stop()
	$meltdown_timer.start()
	if Input.is_key_label_pressed(KEY_T):
		%Camera2D.shake()

func _on_explode_fish_timeout():
	$explodingfish.emitting = true

func lights_switch(nyala):
	# @Kenichi TODO selesaikan ini, light harusnya tidak on off ketika player gantian klik switch
	status_lampu = nyala


func _process(delta):
	if Input.is_key_label_pressed(KEY_R):
		get_tree().reload_current_scene()

func _on_attacked_fish_timer_timeout():
	if can_attacked_fish:
		$attacked_fish_timer.wait_time = randi_range(30,40)
		if not status_lampu:
			GameManager.emit_signal("game_over",GameManager.DEATH_REASON.BIG_FISH)
