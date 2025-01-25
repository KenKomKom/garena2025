extends Sprite2D

var value = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = Time.get_ticks_msec()/1000.0
	material.set_shader_parameter("time", value)
