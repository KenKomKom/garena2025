extends CanvasLayer

@onready var reason = %reason

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.connect("game_over", end)

func end(why):
	visible = true
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
	if Input.is_key_pressed(KEY_A):
		$VBoxContainer/HBoxContainer/A.modulate = Color.GREEN_YELLOW
	if Input.is_key_pressed(KEY_D):
		$VBoxContainer/HBoxContainer/D.modulate = Color.GREEN_YELLOW
