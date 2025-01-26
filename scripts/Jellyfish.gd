extends Node2D

@export var lifetime = 10
const SWIM_POWER = 10
var velocity = Vector2.ZERO
const DRAG = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity
	if velocity.length_squared() <= DRAG*DRAG:
		velocity = velocity - velocity.normalized() * DRAG
	else:
		velocity = Vector2.ZERO

func _on_animated_sprite_2d_frame_changed():
	if $AnimatedSprite2D.frame == 5:
		velocity = transform.y * SWIM_POWER
