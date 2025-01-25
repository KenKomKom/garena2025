extends Control

var value=-2
var change_direction = -1
var emittable = true
@onready var pressure_bar = %ProgressBar

func _ready():
	GameManager.connect("add_pressure_value", add_pressure_value)
	GameManager.connect("game_over", end)
	value = -2

func add_pressure_value(value):
	self.value += value

func _on_timer_timeout():
	pressure_bar.value += value
	if pressure_bar.value>=100 and emittable:
		GameManager.emit_signal("game_over", GameManager.DEATH_REASON.PRESSURE)

func end(_why):
	emittable = false
