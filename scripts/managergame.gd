extends Node

enum ZONE {EPIPELAGIC, MESOPELAGIC, BATHYPELAGIC, ABYSSOPELAGIC, HADAL}
enum ZONE_DURATION {EPIPELAGIC=1, MESOPELAGIC=2, BATHYPELAGIC=3, ABYSSOPELAGIC=3, HADAL=3}
var ZONE_CUMULATIVE_DURATION = { \
	ZONE.EPIPELAGIC:0, \
	ZONE.MESOPELAGIC:1, \
	ZONE.BATHYPELAGIC:3, \
	ZONE.ABYSSOPELAGIC:5, \
	ZONE.HADAL:8} # SETIAP KALI UBAH ZONE_DURATION, HARUS UBAH CUMULATIVE JUGA
enum DEATH_REASON {AIR, PRESSURE, MELTDOWN, BIG_FISH}

var next_level

@onready var background_player = $background
@onready var audiostream1 = $audio1
@onready var audiostream2 = $audio2

signal zone_reached(zona)
signal tutorial_start()
signal add_air_depletion(value)
signal game_over(why)
signal add_pressure_value()
signal start_meltdown()
signal meltdown_done()
signal lights_switch(nyala)

var zone_now = ZONE.MESOPELAGIC :
	set(value):
		zone_now = value
		emit_signal("zone_reached", zone_now)

func play_audio(file_path, pitch=1.0, volume = 0):
	if not audiostream1.playing :
		audiostream1.volume_db=volume
		audiostream1.pitch_scale = pitch
		audiostream1.stream = load(file_path)
		audiostream1.play()
	else :
		audiostream2.volume_db=volume
		audiostream2.pitch_scale = pitch
		audiostream2.stream = load(file_path)
		audiostream2.play()

func play_audio_background(file_path, volume_db=0):
	if background_player.playing:
		var tween = get_tree().create_tween()
		tween.tween_property(background_player, "volume_db", -10, 1)
		await get_tree().create_timer(1).timeout
		background_player.stop()
	background_player.volume_db=-10
	background_player.stream= load(file_path)
	background_player.play()
	var tween = get_tree().create_tween()
	tween.tween_property(background_player, "volume_db", volume_db, 1)
	await get_tree().create_timer(1).timeout
	background_player.volume_db=volume_db

func stop_audio_background():
	var tween = get_tree().create_tween()
	tween.tween_property(background_player, "volume_db", -10, 1)
	await get_tree().create_timer(1).timeout
	background_player.stop()

# player 1&2 left right tolerance
const TOLERANCE = 0.05
var leftp1 = 0
var rightp1 = 0
var leftp2 = 0
var rightp2 = 0

func _process(delta):
	if Input.is_action_just_pressed("leftp1"):
		leftp1 = TOLERANCE
	if Input.is_action_just_pressed("rightp1"):
		rightp1 = TOLERANCE
	if Input.is_action_just_pressed("leftp2"):
		leftp2 = TOLERANCE
	if Input.is_action_just_pressed("rightp2"):
		rightp2 = TOLERANCE
		
	leftp1 -= delta
	rightp1 -= delta
	leftp2 -= delta
	rightp2 -= delta

func get_leftp1():
	return leftp1 > 0

func get_rightp1():
	return rightp1 > 0

func get_leftp2():
	return leftp2 > 0

func get_rightp2():
	return rightp2 > 0
	
func reset_p1():
	leftp1 = 0
	rightp1 = 0
	
func reset_p2():
	leftp2 = 0
	rightp2 = 0
