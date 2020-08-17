extends KinematicBody2D

signal death
signal hurt(damage, health)

export var bullet : PackedScene = preload("res://entities/BlueBullet.tscn")
export var max_health := 6
export var health : int = max_health
export var speed := 100
export var gravity := 20
export var max_fall_speed := 500
export var jump_impulse := 300

var velocity := Vector2.ZERO
var stunned := false
var loading := true
var dying := false

func _ready():
	$AnimationPlayer.play("Spawn")

func _physics_process(delta):
	if loading or dying:
		return
	
	if Input.is_action_just_pressed("attack") and $ShootCooldown.is_stopped():
		var instance = bullet.instance()
		instance.global_position = get_global_mouse_position() + Vector2(6, 6)
		instance.look_at(self.global_position)
		instance.player = self
		$Bullets.add_child(instance)
		$ShootCooldown.start()
	
	var direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	var jump = Input.is_action_just_pressed("jump") and $GroundCheck.is_colliding()
	
	if direction < 0:
		$AnimatedSprite.flip_h = true
	elif direction > 0:
		$AnimatedSprite.flip_h = false
	
	if stunned:
		$AnimatedSprite.play("hurt")
		$SFX/Hurt.play()
		$AnimationPlayer.stop()
	elif not is_on_floor():
		$AnimatedSprite.play("fall")
		$AnimationPlayer.stop()
	elif direction == 0:
		$AnimatedSprite.play("default")
		$AnimationPlayer.stop()
	else:
		$AnimatedSprite.play("run")
		$AnimationPlayer.play("Walking")
	
	if not stunned:
		velocity.x = direction * speed
		if jump:
			velocity.y = -jump_impulse
			$SFX/Jump.play()
		else:
			velocity.y = clamp(velocity.y + gravity, -max_fall_speed, max_fall_speed)
	else:
		velocity.y = clamp(velocity.y + gravity, -max_fall_speed, max_fall_speed)
	
	if is_on_floor():
		velocity = move_and_slide_with_snap(velocity, Vector2(0, 3), Vector2.UP)
	else:
		velocity = move_and_slide(velocity, Vector2.UP)
		if is_on_floor():
			$SFX/Land.play()

func hit(damage, from):
	health -= damage
	if health < 0: 
		health = 0
	emit_signal("hurt", damage, health)
	if health <= 0:
		dying = true
		$AnimationPlayer.play("Die")
	else:
		stunned = true
		$Knockback.start()
		velocity = (global_position - from).normalized()
		velocity.x *= speed
		velocity.y *= jump_impulse
		$AnimatedSprite.play("hurt")


func _on_Knockback_timeout():
	stunned = false


func _on_AnimationPlayer_animation_finished(anim_name):
	match(anim_name):
		"Spawn":
			loading = false
		"Die":
			emit_signal("death")
