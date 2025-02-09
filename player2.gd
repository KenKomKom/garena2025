extends Player

func _physics_process(delta):
	if can_move:
		direction = Input.get_axis("leftp2", "rightp2")
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
		if (target_floor.global_position-global_position).length()<10:
			global_position = target_floor.global_position
			target_floor = null
			can_move = true
			is_climbing = false
			velocity.y = 0
	move_and_slide()
