extends KinematicBody2D

signal death
signal hurt(damage, health)

export var max_health := 3
export var health : int = max_health
export var speed := 100
export var gravity := 20
export var max_fall_speed := 500
export var jump_impulse := 300

var velocity := Vector2.ZERO
var stunned := false

func _ready():
	$AnimatedSprite.play("default")

func _physics_process(delta):
	var direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	var jump = Input.is_action_just_pressed("jump") and $GroundCheck.is_colliding()
	
	if direction < 0:
		$AnimatedSprite.flip_h = true
	elif direction > 0:
		$AnimatedSprite.flip_h = false
	
	if stunned:
		$AnimatedSprite.play("hurt")
	elif not is_on_floor():
		$AnimatedSprite.play("fall")
	elif direction == 0:
		$AnimatedSprite.play("default")
	else:
		$AnimatedSprite.play("run")
	
	if not stunned:
		velocity.x = direction * speed
		if jump:
			velocity.y = -jump_impulse
		else:
			velocity.y = clamp(velocity.y + gravity, -max_fall_speed, max_fall_speed)
	else:
		velocity.y = clamp(velocity.y + gravity, -max_fall_speed, max_fall_speed)
	
	if is_on_floor():
		velocity = move_and_slide_with_snap(velocity, Vector2(0, 3), Vector2.UP)
	else:		
		velocity = move_and_slide(velocity, Vector2.UP)

func hit(damage, from):
	stunned = true
	$Knockback.start()
	velocity = (global_position - from).normalized()
	velocity.x *= speed
	velocity.y *= jump_impulse
	
	$AnimatedSprite.play("hurt")
	
	health -= damage
	emit_signal("hurt", damage, health)
	if health <= 0:
		emit_signal("death")


func _on_Knockback_timeout():
	stunned = false
