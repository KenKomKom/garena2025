extends Label

@onready var depth_timer = $depth_timer
@onready var count_timer = $count_Timer

@export var value := 13

var depth_meter:=0

func _ready():
	GameManager.connect("game_over", end)
	depth_meter = 13 * 60 * GameManager.ZONE_CUMULATIVE_DURATION[GameManager.zone_now]
	depth_timer.wait_time = GameManager.ZONE_DURATION[GameManager.zone_now]*60
	$ProgressBar.max_value = GameManager.ZONE_DURATION[GameManager.zone_now]*60
	depth_timer.start() # count depth in seconds
	count_timer.start() # counter 1 detik

func _on_depth_timer_timeout():
	$ProgressBar.value = 0
	var next_zone = GameManager.zone_now+1
	if GameManager.zone_now>=5:
		print("YOU WON")
		return
	else:
		GameManager.zone_now = next_zone
		depth_timer.wait_time = GameManager.ZONE_DURATION[GameManager.zone_now]*60
		$ProgressBar.max_value = GameManager.ZONE_DURATION[GameManager.zone_now]*60

func _on_count_timer_timeout():
	depth_meter+=value # count depth in meter
	text = "DEPTH : " + str(depth_meter) +"m"
	count_timer.start()
	$ProgressBar.value +=1

func end(_why):
	value = 0
	$depth_timer.stop()
	$count_Timer.stop()
