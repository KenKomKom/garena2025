extends CanvasLayer

var next_level

func _ready():
	next_level = GameManager.next_level
	%ProgressBar.value = 0
	ResourceLoader.load_threaded_request(next_level)

func _process(delta):
	var p =[]
	ResourceLoader.load_threaded_get_status(next_level,p)
	var progres = p[0]*100
	%ProgressBar.value = progres
	if progres==100:
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(next_level))

#LOADING...
#0123456789
func _on_timer_timeout():
	if len(%Label.text)==9:
		%Label.text = "LOADING"
	elif len(%Label.text)==6:
		%Label.text = "LOADING."
	elif len(%Label.text)==7:
		%Label.text = "LOADING.."
	elif len(%Label.text)==8:
		%Label.text = "LOADING..."
