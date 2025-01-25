extends Control

class_name Manual

enum EVENTS {
	TANK,
	MONITOR,
	LEAKS,
	PREDATOR_FISH,
	NUCLEAR_MELTDOWN
}

var _count = 0

const DESC = [
	"In event of an OXYGEN TANK being empty, REPLACE it with one of the tanks piled in the second floor",
	"In event of PRESSURE INCREASE, go to the MONITOR and adjust the gauge",
	"In event of LEAKS, STAND BY the leaks and fix it",
	"In event of a BIG FISH SIGHTED, turn off the lights to not catch the attention of it",
	"In event of a NUCLEAR MELTDOWN, EACH go to the LEVERS on seperate floors and pull it"
]

func add_text(idx):
	%Label.text += "\n"+DESC[idx]
	_count+=1

func _clear_text():
	_count = 0
	%Label.text = ""

func animate_in():
	var tween = get_tree().create_tween()
	tween.tween_property($background, "position", Vector2($background.position.x,1094-350-(_count*100)), 1)
	await get_tree().create_timer(12*_count).timeout
	_animate_out()

func _animate_out():
	var tween = get_tree().create_tween()
	tween.tween_property($background, "position", Vector2($background.position.x,1094), 1)
	await tween.finished
	_clear_text()
	
