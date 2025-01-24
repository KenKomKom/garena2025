extends Control

var value=0
var change_direction = -1
@onready var pressure_bar = %ProgressBar
@export var change_rate := 3

func _ready():
	GameManager.connect("pressure_dir", pressure_dir)

func pressure_dir(dir:int):
	change_direction = dir

func _on_timer_timeout():
	pressure_bar.value += change_direction * change_rate
	if pressure_bar.value>=100:
		GameManager.emit_signal("game_over", GameManager.DEATH_REASON.PRESSURE)
