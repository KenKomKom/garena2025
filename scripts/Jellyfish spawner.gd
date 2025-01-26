extends Node2D

var jellyfish = preload("res://scenes/jellyfish.tscn")
var poses = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var children = get_children()
	
	for c in children:
		if c is Marker2D:
			poses.push_back(c)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	if GameManager.zone_now >= GameManager.ZONE.BATHYPELAGIC:
		for i in range(randi_range(1, GameManager.zone_now+3)):
			var j = jellyfish.instantiate()
			add_child(j)
			j.position = poses.pick_random().position
			j.rotation = randf_range(-PI/6, PI/6)
			await get_tree().create_timer(0.3).timeout
