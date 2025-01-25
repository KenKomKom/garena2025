extends Node2D

var oxygen_level = 100
var pressure_level = 0

var live_tank :=3

var bocor_preload = preload("res://scenes/bocor.tscn")
var can_bocor = false
var can_meltdown = false
var can_attacked_fish = false

var status_lampu = false
var is_aggresive_fish_in_death_area = false

@onready var list_of_available_bocor_spot := $Node2D

func _ready():
	GameManager.connect("zone_reached", bocor_mulai)
	GameManager.connect("meltdown_done", meltdown_done)
	GameManager.connect("lights_switch", lights_switch)
	GameManager.emit_signal("start_meltdown")

func bocor_mulai(zone):
	match zone:
		GameManager.ZONE.EPIPELAGIC:
			# Level 1
			can_attacked_fish = true # TODO: HAPUS
			var p = %manual as Manual
			p.add_text(p.EVENTS.TANK)
			p.add_text(p.EVENTS.MONITOR)
			p.animate_in()
		GameManager.ZONE.MESOPELAGIC:
			# Level 2
			can_bocor = true
			$bocor_timer.start()
			var p = %manual as Manual
			p.add_text(p.EVENTS.LEAKS)
			p.add_text(p.EVENTS.PREDATOR_FISH)
			p.animate_in()
		GameManager.ZONE.BATHYPELAGIC:
			# Level 3
			can_meltdown = true
			can_attacked_fish = true
			$meltdown_timer.start()
			var p = %manual as Manual
			p.add_text(p.EVENTS.NUCLEAR_MELTDOWN)
			p.animate_in()
		GameManager.ZONE.ABYSSOPELAGIC:
			# Level 4
			can_meltdown = true
			can_attacked_fish = true
			$meltdown_timer.start()
		GameManager.ZONE.HADAL:
			# Level 5
			can_meltdown = true
			can_attacked_fish = true
			$meltdown_timer.start()

func instantiate_bocor():
	var temp = bocor_preload.instantiate()
	var marker = list_of_available_bocor_spot.get_child(randi_range(0,list_of_available_bocor_spot.get_child_count()-1))
	if marker.get_child_count()>1:
		return
	marker.add_child(temp)
	temp.global_position = marker.global_position

func _on_bocor_timer_timeout():
	print("bocor bocor", can_bocor)
	if can_bocor:
		for i in range(randi_range(2,5)):
			instantiate_bocor()
		$bocor_timer.wait_time = randi_range(15,25)

func _on_meltdown_timer_timeout():
	if can_meltdown:
		GameManager.emit_signal("start_meltdown")
		$meltdown_timer.wait_time = 3

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
	%SubmarineMain.is_on = nyala
	status_lampu = nyala

func _process(delta):
	if Input.is_key_label_pressed(KEY_R):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("ui_accept"):
		_on_attacked_fish_timer_timeout()
		
	# check if fish is in death area
	if is_aggresive_fish_in_death_area and status_lampu:
		GameManager.emit_signal("game_over",GameManager.DEATH_REASON.BIG_FISH)

func _on_attacked_fish_timer_timeout():
	if can_attacked_fish:
		$attacked_fish_timer.wait_time = randi_range(30,40) - GameManager.zone_now*2
		
		var tween = get_tree().create_tween()
		const mid = Vector2(960, 540)
		const range_anim = 3000
		const duration = 10
		var rand_angle = randf_range(-PI/4, PI/4)
		if randi() % 2 == 1:
			# dari ke kiri mau ke kanan
			$Fishes/Fish.rotation = rand_angle
			$Fishes/Fish/Sprite2D.flip_h = false
		else:
			# dari kanan mau ke kiri
			$Fishes/Fish.rotation = rand_angle
			$Fishes/Fish/Sprite2D.flip_h = true
			rand_angle += PI
			
		$Fishes/Fish.position = mid + Vector2(-cos(rand_angle), -sin(rand_angle)) * range_anim
		
		tween.tween_property($Fishes/Fish, "position", Vector2(mid - Vector2(-cos(rand_angle), -sin(rand_angle)) * range_anim), duration).set_trans(Tween.TRANS_LINEAR)
		#tween.tween_callback($Fishes/Fish.queue_free)
		
		
