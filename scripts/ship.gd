extends Node2D

var live_tank :=3

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.connect("tank_minus", air_minus)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func air_minus():
	live_tank-=1
