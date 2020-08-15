extends KinematicBody2D

export var speed := 100
export var gravity := 20
export var max_fall_speed := 500
export var jump_impulse := -300

var velocity := Vector2.ZERO

func _ready():
	$AnimatedSprite.play("default")

func _physics_process(delta):
	var direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	var jump = Input.is_action_just_pressed("jump") and $GroundCheck.is_colliding()
	
	if direction < 0:
		$AnimatedSprite.flip_h = true
	elif direction > 0:
		$AnimatedSprite.flip_h = false
	
	if not is_on_floor():
		$AnimatedSprite.play("fall")
	elif direction == 0:
		$AnimatedSprite.play("default")
	else:
		$AnimatedSprite.play("run")
	
	velocity.x = direction * speed
	if jump:
		velocity.y = jump_impulse
	else:
		velocity.y = clamp(velocity.y + gravity, -max_fall_speed, max_fall_speed)
	
	if is_on_floor():
		velocity = move_and_slide_with_snap(velocity, Vector2(0, 3), Vector2.UP)
	else:		
		velocity = move_and_slide(velocity, Vector2.UP)
