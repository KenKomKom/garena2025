extends Node2D

@onready var spawner = preload("res://scenes/jellyfish.tscn")
var poses = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var children = get_children()
	
	for c in children:
		if c is Marker2D:
			poses.push_back(poses)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	if GameManager.zone_now >= GameManager.ZONE.BATHYPELAGIC:
		for i in range(randi_range(1, 7)):
			var j = spawner.instantiate()
			add_child(j)
			j.position = poses.pick_random().position
			j.rotation = PI/2 + randf_range(-PI/4, PI/4)
			await get_tree().create_timer(0.3).timeout
