extends Node2D

var oxygen_level = 100
var pressure_level = 0

var live_tank :=3



func _ready():
	GameManager.connect("tank_minus", air_minus)
	


func _process(delta):
	$Label.text = "oxygen: " + str(oxygen_level) + "\npressure: " + str(pressure_level)

func air_minus():
	live_tank-=1
