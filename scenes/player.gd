extends CharacterBody2D

const UP_ACCELERATION = -800.0
const GRAVITY = 800.0
const MAX_UP_SPEED = -400.0
const MAX_DOWN_SPEED = 600.0

const MAX_ROTATION_UP = -30.0
const MAX_ROTATION_DOWN = 30.0
const ROTATION_SPEED = 6.0

var game_started: bool = false
var original_y: float
var float_time := 0.0

enum State {
	NORMAL,
	BOOSTED,
	CRASHING
}

var state: State = State.NORMAL

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	GlobalEvents.ennemyhit.connect(_on_ennemy_hit)
	original_y = position.y


func _on_ennemy_hit(body: Node2D) -> void:
	if body == self && game_started:
		state = State.CRASHING
		print("Player is crashing from global event!")


func _physics_process(delta: float) -> void:
	if not game_started:
		float_time += delta
		velocity = Vector2.ZERO  # Stop any inherited motion
		position.y = original_y + sin(float_time * 2.0) * 10.0  # Float gently
		return  # Skip gravity/movement logic

	match state:
		State.CRASHING:
			velocity.y += GRAVITY * delta
			sprite.play("default")
			move_and_slide()
			return

		State.BOOSTED:
			velocity.y += UP_ACCELERATION * delta
			sprite.play("boosting")
			if !Input.is_action_pressed("action") or FuelStore.fuelAmount <= 0:
				state = State.NORMAL

		State.NORMAL:
			if Input.is_action_pressed("action") and FuelStore.fuelAmount > 0:
				state = State.BOOSTED
				return
			velocity.y += GRAVITY * delta
			sprite.play("default")

	velocity.y = clamp(velocity.y, MAX_UP_SPEED, MAX_DOWN_SPEED)
	move_and_slide()
	position.y = max(position.y, 0)

	var target_angle = clamp(velocity.y / MAX_DOWN_SPEED, -1.0, 1.0) * MAX_ROTATION_DOWN
	rotation_degrees = lerp(rotation_degrees, target_angle, ROTATION_SPEED * delta)
