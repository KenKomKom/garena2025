extends Node

enum ZONE {EPIPELAGIC, MESOPELAGIC, BATHYPELAGIC, ABYSSOPELAGIC, HADAL}
enum ZONE_DURATION {EPIPELAGIC=2, MESOPELAGIC=3, BATHYPELAGIC=3, ABYSSOPELAGIC=3, HADAL=3}
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

var zone_now = ZONE.EPIPELAGIC :
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
