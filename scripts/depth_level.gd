extends Label

@onready var depth_timer = $depth_timer
@onready var count_timer = $count_Timer

@export var value := 13

var depth_meter:=0

func _ready():
	depth_meter = 13 * 60 * GameManager.ZONE_CUMULATIVE_DURATION[GameManager.zone_now]
	depth_timer.wait_time = GameManager.ZONE_DURATION.EPIPELAGIC*60
	GameManager.zone_now = GameManager.ZONE.EPIPELAGIC
	depth_timer.start()
	count_timer.start()

func _on_depth_timer_timeout():
	match GameManager.zone_now:
		GameManager.ZONE.EPIPELAGIC:
			GameManager.zone_now = GameManager.ZONE.MESOPELAGIC
			depth_timer.wait_time = GameManager.ZONE_DURATION.MESOPELAGIC*60
			$ProgressBar.max_value = GameManager.ZONE_DURATION.MESOPELAGIC*60
		GameManager.ZONE.MESOPELAGIC:
			GameManager.zone_now = GameManager.ZONE.BATHYPELAGIC
			depth_timer.wait_time = GameManager.ZONE_DURATION.BATHYPELAGIC*60
			$ProgressBar.max_value = GameManager.ZONE_DURATION.BATHYPELAGIC*60
		GameManager.ZONE.BATHYPELAGIC:
			GameManager.zone_now = GameManager.ZONE.ABYSSOPELAGIC
			depth_timer.wait_time = GameManager.ZONE_DURATION.ABYSSOPELAGIC*60
			$ProgressBar.max_value = GameManager.ZONE_DURATION.ABYSSOPELAGIC*60
		GameManager.ZONE.ABYSSOPELAGIC:
			GameManager.zone_now = GameManager.ZONE.HADAL
			depth_timer.wait_time = GameManager.ZONE_DURATION.HADAL*60
			$ProgressBar.max_value = GameManager.ZONE_DURATION.HADAL*60

func _on_count_timer_timeout():
	depth_meter+=value
	text = "DEPTH : " + str(depth_meter) +"m"
	count_timer.start()
	$ProgressBar.value +=1

func end(_why):
	value = 0
