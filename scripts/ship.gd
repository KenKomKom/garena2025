extends Node2D

var oxygen_level = 100
var pressure_level = 0

var live_tank :=3



func _ready():
	GameManager.connect("tank_minus", air_minus)
	pass # Replace with function body.


func _process(delta):
	pass

func air_minus():
	live_tank-=1
