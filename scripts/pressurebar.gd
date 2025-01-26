extends Control

var value=-2
var change_direction = -1
var emittable = true
@onready var pressure_bar = %ProgressBar

func _ready():
	visible = true
	GameManager.connect("add_pressure_value", add_pressure_value)
	GameManager.connect("increase_pressure_bar", increase)
	GameManager.connect("game_over", end)
	GameManager.connect("stop_all", stop_all)
	GameManager.connect("win", end)

func stop_all():
	visible = false
	emittable = false

func add_pressure_value(value):
	self.value += value

func _on_timer_timeout():
	pressure_bar.value += value
	if pressure_bar.value>=100 and emittable:
		GameManager.emit_signal("game_over", GameManager.DEATH_REASON.PRESSURE)
	if pressure_bar.value < 0:
		pressure_bar.value = 0
		
func increase():
	pressure_bar.value -= 30

func end(_why=null):
	emittable = false
	visible = false
