extends Node2D

var oxygen_level = 100
var pressure_level = 0

var live_tank :=3

var bocor_preload = preload("res://scenes/bocor.tscn")
var can_bocor = false
var can_meltdown = false
var can_attacked_fish = false

var status_lampu = true
var is_aggresive_fish_in_death_area = 0

var has_won = false
var once = true

@onready var list_of_available_bocor_spot := $Node2D

const sea_color = ["#89d9c7","#345885","#212a64","#120d36","#07041f"]

@onready var fish_ok = preload("res://scenes/fish_ok.tscn")
@onready var fish_odd = preload("res://scenes/fish_odd.tscn")
@onready var fish_big = preload("res://scenes/fish_big.tscn")

func _ready():
	print("game startedd")
	GameManager.connect("zone_reached", bocor_mulai)
	GameManager.connect("meltdown_done", meltdown_done)
	GameManager.connect("lights_switch", lights_switch)
	GameManager.connect("win", win)
	#GameManager.emit_signal("win")
	GameManager.emit_signal("zone_reached", GameManager.zone_now)
	$ikan_death.visible = false
	$glass.visible = false
	once = true
	$CanvasLayer/ColorRect.modulate.a = 0
	#GameManager.emit_signal("win")
	#set_up_death_by_fish()
	GameManager.play_audio_background("res://audio/LDj_Audio - Submarine Ambience (Mp3).mp3",-3)
	
func bocor_mulai(zone):
	var tween = get_tree().create_tween()
	if zone >= 5:
		return
	tween.tween_property($Water, "modulate", Color(sea_color[zone]),4)
	tween.tween_property($Godray, "modulate", Color(1, 1, 1, (4-zone)/4.0),4)
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
		for i in range(randi_range(1,3)):
			instantiate_bocor()
		$bocor_timer.wait_time = randi_range(20, 25) - GameManager.zone_now

func _on_meltdown_timer_timeout():
	if can_meltdown:
		%SubmarineMain.is_meltdown = true
		GameManager.emit_signal("start_meltdown")
		$menltdown_kill.start()
		GameManager.play_meltdown()

func _on_menltdown_kill_timeout():
	GameManager.emit_signal("game_over", GameManager.DEATH_REASON.MELTDOWN)

func meltdown_done():
	GameManager.stop_meltdown()
	%SubmarineMain.is_meltdown = false
	$menltdown_kill.stop()
	$meltdown_timer.stop()
	$meltdown_timer.start()

func _on_explode_fish_timeout():
	#$explodingfish.emitting = true
	pass
	# @ken ini buat apa

func lights_switch(nyala):
	%SubmarineMain.is_on = nyala
	status_lampu = nyala

func _process(delta):
	
	if has_won:
		if Input.is_action_just_pressed("leftp1") and Input.is_action_just_pressed("rightp1"):
			get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")
	
	if Input.is_key_label_pressed(KEY_R):
		get_tree().reload_current_scene()
	
	# fish cheatcode
	#if Input.is_action_just_pressed("ui_accept"):
		#_on_attacked_fish_timer_timeout()
		
	# check if fish is in death area
	if is_aggresive_fish_in_death_area>0 and status_lampu:
		if once:
			once = false
			set_up_death_by_fish()
	
	if Input.is_action_just_pressed("ui_accept"):
		_on_attacked_fish_timer_timeout()

func _on_attacked_fish_timer_timeout():
	if can_attacked_fish:
		# spawn fish
		%Camera2D.shake()
		GameManager.emit_signal("spawn_radar")
		$attacked_fish_timer.stop()
		
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
			if randi() % 2 == 1:
				a.scale.x = -1
			else:
				a.scale.x = 1
		else:
			if randi() % 2 == 1:
				# dari ke kiri mau ke kanan
				a.rotation = rand_angle
				a.scale.x = 1
			else:
				# dari kanan mau ke kiri
				a.rotation = rand_angle
				a.scale.x = -1
				rand_angle += PI
				
		a.position = mid + Vector2(-cos(rand_angle), -sin(rand_angle)) * range_anim
			
		tween.tween_property(a, "position", Vector2(mid - Vector2(-cos(rand_angle), -sin(rand_angle)) * range_anim), duration).set_trans(Tween.TRANS_LINEAR)
		tween.tween_callback(func(): 
			if is_instance_valid(a):
				a.queue_free
			$attacked_fish_timer.wait_time = randi_range(50,80) - GameManager.zone_now*2
			$attacked_fish_timer.start()
		)

func set_up_death_by_fish():
	%Camera2D.shake()
	$glass.visible = true
	GameManager.play_audio("res://audio/GlassBreakCracksG PE1050903.wav")
	await get_tree().create_timer(2).timeout
	
	GameManager.emit_signal("stop_all")
	
	# Delete all fishes
	var group_nodes = get_tree().get_nodes_in_group("fish")
	for node in group_nodes:
		node.queue_free()
	
	GameManager.play_audio("res://audio/Power Off 01.mp3")
	
	await get_tree().create_timer(1).timeout
	
	%Camera2D.shake()
	$ikan_death.visible = true
	$ikan_death.play("pp")
	var tween = get_tree().create_tween()
	tween.tween_property($PointLight2D, "energy", 3,2).set_ease(Tween.EASE_OUT)
	await $ikan_death.animation_finished
	await get_tree().create_timer(2).timeout
	GameManager.emit_signal("game_over", GameManager.DEATH_REASON.BIG_FISH)

func win():
	%Camera2D.shake()
	$glass.visible = true
	var fucks = $Node2D2.get_children()
	for f in fucks:
		f.run()
	await get_tree().create_timer(1).timeout
	var tween = get_tree().create_tween()
	tween.tween_property($CanvasLayer/ColorRect, "modulate:a", 1,3).set_ease(Tween.EASE_OUT)
	await tween.finished
	has_won = true
