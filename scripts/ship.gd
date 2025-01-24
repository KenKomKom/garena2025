extends Node2D

var oxygen_level = 100
var pressure_level = 0

var live_tank :=3

var bocor_preload = preload("res://scenes/bocor.tscn")
var can_bocor = false
var can_meltdown = false

@onready var list_of_available_bocor_spot := $Node2D

func _ready():
	GameManager.connect("zone_reached", bocor_mulai)
	GameManager.connect("meltdown_done", meltdown_done)
	bocor_mulai(GameManager.ZONE.BATHYPELAGIC)
	GameManager.emit_signal("start_meltdown")

func bocor_mulai(zone):
	match zone:
		GameManager.ZONE.BATHYPELAGIC:
			can_bocor = true
			$bocor_timer.start()
		GameManager.ZONE.ABYSSOPELAGIC:
			can_meltdown = true
			$meltdown_timer.start()

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
		$meltdown_timer.wait_time = randi_range(30,40)

func _process(delta):
	if Input.is_key_label_pressed(KEY_R):
		get_tree().reload_current_scene()

func _on_menltdown_kill_timeout():
	GameManager.emit_signal("gameover", GameManager.DEATH_REASON.MELTDOWN)

func meltdown_done():
	$menltdown_kill.stop()
	$meltdown_timer.stop()
	$meltdown_timer.start()
