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

func _ready():
	GameManager.connect("zone_reached", add_text2)

const DESC = [
	"In event of an OXYGEN TANK being empty, REPLACE it with one of the tanks piled in the second floor",
	"In event of PRESSURE INCREASE, go to the MONITOR and adjust the gauge",
	"In event of LEAKS, STAND BY the leaks and fix it",
	"In event of a BIG FISH SIGHTED, turn off the lights to not catch the attention of it",
	"In event of a NUCLEAR MELTDOWN, EACH go to the LEVERS on seperate floors and pull it"
]

func add_text(idx):
	%Label.text += "\n\n"+DESC[idx]
	_count+=1

func add_text2(type):
	%congrats.text = "NEW ZONE REACHED: "
	match GameManager.zone_now:
		GameManager.ZONE.EPIPELAGIC:
			%congrats.text += "EPIPELAGIC"
		GameManager.ZONE.MESOPELAGIC:
			%congrats.text += "MESOPELAGIC"
		GameManager.ZONE.BATHYPELAGIC:
			%congrats.text += "BATHYPELAGIC"
		GameManager.ZONE.ABYSSOPELAGIC:
			%congrats.text += "ABYSSOPELAGIC"

func _clear_text():
	_count = 0
	%Label.text = ""

func animate_in():
	var tween = get_tree().create_tween()
	tween.tween_property($background, "position", Vector2($background.position.x,1094-100-(_count*120)), 1)
	await get_tree().create_timer(6*_count).timeout
	_animate_out()

func _animate_out():
	var tween = get_tree().create_tween()
	tween.tween_property($background, "position", Vector2($background.position.x,1094), 1)
	await tween.finished
	_clear_text()
	
