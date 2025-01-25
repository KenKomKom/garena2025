extends CanvasLayer

@onready var reason = %reason

const INPUT_DISABLE_DURATION = 1
var timer = 0;
var once = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.connect("game_over", end)

func end(why):
	if !once:
		timer = INPUT_DISABLE_DURATION
		
		visible = true
		var tween = get_tree().create_tween()
		tween.tween_property($ColorRect, "modulate:a", 1,0.4)
		
		once = true
		match why:
			GameManager.DEATH_REASON.AIR:
				reason.text = "YOU DIED OF SUFFOCATION"
			GameManager.DEATH_REASON.PRESSURE:
				reason.text = "THE SHIP IMPLODED"
			GameManager.DEATH_REASON.MELTDOWN:
				reason.text = "YOU DIED OF RADIATION POISONING"
			GameManager.DEATH_REASON.BIG_FISH:
				reason.text = "THE SHIP CRASHED DUE TO UNFORSEEN CIRCUMSTENCES"

func _process(delta):
	timer -= delta
	if timer <= 0:
		if Input.is_key_pressed(KEY_A) and visible:
			# back to checkpoint
			GameManager.play_audio("res://audio/buttons-67224.ogg")
			await get_tree().create_timer(0.2).timeout
			visible = false
			get_tree().reload_current_scene()
			
		if Input.is_key_pressed(KEY_D) and visible:
			# go to main menu
			GameManager.play_audio("res://audio/buttons-67224.ogg")
			await get_tree().create_timer(0.2).timeout
			get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")
		
