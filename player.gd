class_name  Player extends CharacterBody2D

var SPEED = 500.0
var direction = Vector2.ZERO
@export var player_number=1

var can_move = true:
	set(val):
		if is_dead:
			can_move = false
		else:
			can_move = val
var is_climbing = false
var target_floor = null

var is_tanky = false:
	set(val):
		is_tanky = val
		$tanky.visible=val
var initial_pos

var is_dead = false

func _ready():
	initial_pos = position
	GameManager.connect("game_over", end)
	GameManager.connect("stop_all", stop_all)

func stop_all():
	is_dead = true
	can_move = false

func _physics_process(delta):
	if can_move:
		direction = Input.get_axis("leftp1", "rightp1")
		if direction:
			$AnimatedSprite2D.play("p1_walk")
			$AnimatedSprite2D.flip_h = true if direction<0	 else false
			velocity.x = direction * SPEED
		else:
			
			$AnimatedSprite2D.play("p1_idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
	elif not can_move and is_climbing:
		if direction:
			$AnimatedSprite2D.play('p1_climb')
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
			is_climbing = false
			velocity.y = 0
	move_and_slide()

func set_move_to_target(target):
	can_move = false
	is_climbing = true
	target_floor = target
	direction = (target.global_position-global_position).normalized()

func set_is_tanky(boolean):
	is_tanky = boolean

func end(_why=null):
	is_dead = true
	can_move = false
	is_climbing = false
	velocity = Vector2.ZERO
	$AnimatedSprite2D.play("p1_idle")
