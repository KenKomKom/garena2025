extends PointLight2D

# @Ken USAGE:
# %SubmarineMain.is_on = is_light_on
# %SubmarineMain.is_meltdown = is_meltdown


var is_enable = false

@export var normal_color : Color
@export var emergency_color : Color

var is_on = true
var is_meltdown = true

const FREQ = 0.6


func _process(delta):
	if not is_on:
		# off
		color = Color(0, 0, 0, 0)
	elif is_meltdown:
		# meltdown
		color = lerp(normal_color, emergency_color, sin(Time.get_ticks_msec()/1000.0*FREQ*2*PI))
	else:
		color = normal_color


