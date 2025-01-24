class_name  Player extends CharacterBody2D

var SPEED = 300.0
var direction = Vector2.ZERO
@export var player_number=1

var can_move = true
var target_floor = null

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if can_move:
		direction = Input.get_axis("leftp1", "rightp1")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		if direction:
			velocity.y = direction.y * SPEED
			velocity.x = direction.x * SPEED
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)
			velocity.x = move_toward(velocity.x, 0, SPEED)
		#print((target_floor.global_position-global_position).length())
		if (target_floor.global_position-global_position).length()<10:
			global_position = target_floor.global_position
			target_floor = null
			can_move = true
			velocity.y = 0
	move_and_slide()

func set_move_to_target(target):
	can_move = false
	target_floor = target
	direction = (target.global_position-global_position).normalized()
	print(direction)
