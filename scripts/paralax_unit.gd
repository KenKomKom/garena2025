extends Sprite2D

@export var durasi := 1.0

# Called when the node enters the scene tree for the first time.
func run():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(0,-126.491),durasi).set_ease(Tween.EASE_OUT)
