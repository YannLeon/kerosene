extends CharacterBody2D

const UP_ACCELERATION = -800.0
const GRAVITY = 800.0
const MAX_UP_SPEED = -400.0
const MAX_DOWN_SPEED = 600.0

const MAX_ROTATION_UP = -30.0
const MAX_ROTATION_DOWN = 30.0
const ROTATION_SPEED = 6.0

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		velocity.y += UP_ACCELERATION * delta
	else:
		velocity.y += GRAVITY * delta

	velocity.y = clamp(velocity.y, MAX_UP_SPEED, MAX_DOWN_SPEED)

	move_and_slide()

	# ⛔ Prevent flying above y = 0
	position.y = max(position.y, 0)

	var target_angle = clamp(velocity.y / MAX_DOWN_SPEED, -1.0, 1.0) * MAX_ROTATION_DOWN
	rotation_degrees = lerp(rotation_degrees, target_angle, ROTATION_SPEED * delta)
