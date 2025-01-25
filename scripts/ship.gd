extends Node2D

var oxygen_level = 100
var pressure_level = 0

var live_tank :=3

var bocor_preload = preload("res://scenes/bocor.tscn")
var can_bocor = false
var can_meltdown = false
var can_attacked_fish = false

var status_lampu = false
var is_aggresive_fish_in_death_area = 0

@onready var list_of_available_bocor_spot := $Node2D

const sea_color = ["#9bf1de","#4174a7","#2c3884","#231760","#100838"]

@onready var fish_ok = preload("res://scenes/fish_Ok.tscn")
@onready var fish_odd = preload("res://scenes/fish_Odd.tscn")
@onready var fish_big = preload("res://scenes/fish_Big.tscn")


func _ready():
	GameManager.connect("zone_reached", bocor_mulai)
	GameManager.connect("meltdown_done", meltdown_done)
	GameManager.connect("lights_switch", lights_switch)
	GameManager.emit_signal("zone_reached", GameManager.zone_now)
	GameManager.play_audio("res://audio/LDj_Audio - Submarine Ambience (Mp3).mp3",1,-10)
	
func bocor_mulai(zone):
	$Water.modulate = sea_color[zone]
	match zone:
		GameManager.ZONE.EPIPELAGIC:
			# Level 1
			can_bocor = false
			can_meltdown = false
			can_attacked_fish = false
			var p = %manual as Manual
			p.add_text(p.EVENTS.TANK)
			p.add_text(p.EVENTS.MONITOR)
			p.animate_in()
		GameManager.ZONE.MESOPELAGIC:
			# Level 2
			can_bocor = true
			$bocor_timer.start()
			can_attacked_fish = false
			$attacked_fish_timer.start()
			var p = %manual as Manual
			p.add_text(p.EVENTS.LEAKS)
			p.add_text(p.EVENTS.PREDATOR_FISH)
			p.animate_in()
		GameManager.ZONE.BATHYPELAGIC:
			# Level 3
			can_bocor = true
			$bocor_timer.start()
			can_meltdown = true
			$meltdown_timer.start()
			can_attacked_fish = true
			$attacked_fish_timer.start()
			var p = %manual as Manual
			p.add_text(p.EVENTS.NUCLEAR_MELTDOWN)
			p.animate_in()
		GameManager.ZONE.ABYSSOPELAGIC:
			# Level 4
			can_bocor = true
			$bocor_timer.start()
			can_meltdown = true
			$meltdown_timer.start()
			can_attacked_fish = true
			$attacked_fish_timer.start()
			var p = %manual as Manual
			p.add_text2(GameManager.zone_now)
			p.animate_in()
		GameManager.ZONE.HADAL:
			# Level 5
			can_bocor = true
			$bocor_timer.start()
			can_meltdown = true
			$meltdown_timer.start()
			can_attacked_fish = true
			$attacked_fish_timer.start()
			var p = %manual as Manual
			p.add_text2(GameManager.zone_now)
			p.animate_in()

func instantiate_bocor():
	var temp = bocor_preload.instantiate()
	var marker = list_of_available_bocor_spot.get_child(randi_range(0,list_of_available_bocor_spot.get_child_count()-1))
	if marker.get_child_count()>=1:
		return
	marker.add_child(temp)
	temp.global_position = marker.global_position

func _on_bocor_timer_timeout():
	if can_bocor:
		for i in range(randi_range(3,5)):
			instantiate_bocor()
		$bocor_timer.wait_time = randi_range(15,25)

func _on_meltdown_timer_timeout():
	if can_meltdown:
		%SubmarineMain.is_meltdown = true
		GameManager.emit_signal("start_meltdown")
		$menltdown_kill.start()
		GameManager.play_audio("res://audio/BOATSub_Submarine Sonar Beep Blips.wav")

func _on_menltdown_kill_timeout():
	GameManager.emit_signal("game_over", GameManager.DEATH_REASON.MELTDOWN)

func meltdown_done():
	%SubmarineMain.is_meltdown = false
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
	if is_aggresive_fish_in_death_area>0 and status_lampu:
		GameManager.emit_signal("game_over",GameManager.DEATH_REASON.BIG_FISH)

func _on_attacked_fish_timer_timeout():
	if can_attacked_fish:
		$attacked_fish_timer.wait_time = randi_range(20,30) - GameManager.zone_now*2
		
		var tween = get_tree().create_tween()
		const mid = Vector2(960, 540)
		const range_anim = 3000
		const duration = 20
		var rand_angle = randf_range(-PI/4, PI/4)
		
		# instantiate new fish
		# {EPIPELAGIC, MESOPELAGIC, BATHYPELAGIC, ABYSSOPELAGIC, HADAL}
		var a
		if GameManager.zone_now == GameManager.ZONE.BATHYPELAGIC:
			a = fish_ok.instantiate()
		elif GameManager.zone_now == GameManager.ZONE.ABYSSOPELAGIC:
			a = fish_odd.instantiate()
		else:
			a = fish_big.instantiate()
		add_child(a)
			
		if GameManager.zone_now == GameManager.ZONE.ABYSSOPELAGIC:
			# pengecualian abyssopelagic, aggresive fish swim dari bawah ke atas
			rand_angle -= PI/2
			
		else:
			if randi() % 2 == 1:
				# dari ke kiri mau ke kanan
				a.rotation = rand_angle
				a.get_node("Sprite2D").flip_h = false
			else:
				# dari kanan mau ke kiri
				a.rotation = rand_angle
				a.get_node("Sprite2D").flip_h = true
				rand_angle += PI
				
		a.position = mid + Vector2(-cos(rand_angle), -sin(rand_angle)) * range_anim
			
		tween.tween_property(a, "position", Vector2(mid - Vector2(-cos(rand_angle), -sin(rand_angle)) * range_anim), duration).set_trans(Tween.TRANS_LINEAR)
		tween.tween_callback(a.queue_free)
		
