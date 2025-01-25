extends Control

var value = 3
var emittable = true
@onready var o2bar = %ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.connect("add_air_depletion", add_air_depletion)
	GameManager.connect("game_over", end)

func add_air_depletion(value):
	self.value = min(3, self.value + value)
	print_debug(self.value)

func _on_timer_timeout():
	o2bar.value = min(100,o2bar.value+value)
	var c = o2bar.get_theme_stylebox("background").bg_color
	o2bar.get_theme_stylebox("background").bg_color = Color(c.r-(value*2/255.0), c.g+(value/2/255.0), c.b+(value/2/255.0))
	c = o2bar.get_theme_stylebox("fill").bg_color
	o2bar.get_theme_stylebox("fill").bg_color = Color(c.r-(value*1.5/255.0), c.g+(value/255.0), c.b+(value/255.0))
	#print(o2bar.get_theme_stylebox("background").bg_color)
	if o2bar.value<=0 and emittable:
		GameManager.emit_signal("game_over", GameManager.DEATH_REASON.AIR)

func end(_why):
	emittable = false
