extends Control

var value = 6
var emittable = true
@onready var o2bar = %ProgressBar
var bg_color = Color("#2b5695")
var fill_color =Color("#5bb2a3")

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.connect("add_air_depletion", add_air_depletion)
	GameManager.connect("game_over", end)
	o2bar.get_theme_stylebox("background").bg_color = bg_color
	o2bar.get_theme_stylebox("fill").bg_color = fill_color
	print(fill_color, bg_color)
	value = 6

func add_air_depletion(value):
	self.value = self.value + value
	print_debug(self.value)
	$Label.text = $Label.text + " " + str(value)

func _on_timer_timeout():
	o2bar.value = min(100,o2bar.value+value)
	if o2bar.value<100:
		var c = o2bar.get_theme_stylebox("background").bg_color
		o2bar.get_theme_stylebox("background").bg_color = Color(c.r-(value*2/255.0), c.g+(value/2/255.0), c.b+(value/2/255.0))
		c = o2bar.get_theme_stylebox("fill").bg_color
		o2bar.get_theme_stylebox("fill").bg_color = Color(c.r-(value*1.5/255.0), c.g+(value/255.0), c.b+(value/255.0))
	if o2bar.value<=0 and emittable:
		GameManager.emit_signal("game_over", GameManager.DEATH_REASON.AIR)

func end(_why):
	emittable = false
