extends Control

var value = 3
@onready var o2bar = %ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.connect("add_air_depletion", add_air_depletion)

func add_air_depletion(value):
	self.value = min(3, self.value + value)

func _on_timer_timeout():
	o2bar.value = min(100,o2bar.value+value)
	if o2bar.value<=0:
		GameManager.emit_signal("game_over", GameManager.DEATH_REASON.AIR)
