extends Node2D

@export var lifetime = 10
const SWIM_POWER = 300
const DRAG = 200



var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += velocity * delta
	if velocity.length_squared() > DRAG*DRAG*delta:
		velocity = velocity - velocity.normalized() * DRAG*delta
	else:
		velocity = Vector2.ZERO

func _on_animated_sprite_2d_frame_changed():
	print($AnimatedSprite2D.frame)
	if $AnimatedSprite2D.frame == 5:
		velocity = -transform.y * SWIM_POWER


func _on_animated_sprite_2d_sprite_frames_changed():
	pass
