extends Node2D

var oxygen_level = 100
var pressure_level = 0

var live_tank :=3

var bocor_preload = preload("res://scenes/bocor.tscn")
var can_bocor = false

@onready var list_of_available_bocor_spot := $Node2D

func _ready():
	GameManager.connect("zone_reached", bocor_mulai)
	bocor_mulai(GameManager.ZONE.EPIPELAGIC)

func bocor_mulai(zone):
	match zone:
		GameManager.ZONE.EPIPELAGIC:
			can_bocor = true
			$bocor_timer.start()

func instantiate_bocor():
	print("bocor bocor")
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
		$bocor_timer.wait_time = randi_range(9,12)
