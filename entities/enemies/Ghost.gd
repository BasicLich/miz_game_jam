extends KinematicBody2D

signal die

export var damage := 1
export var health := 2
export var knockback_strength := 300
export var friction := 10
export var gravity := 10
export var max_speed := 50
export var speed := 50

var velocity := Vector2.ZERO
var stunned := false

func _ready():
	$AnimationPlayer.play("default")

func _physics_process(_delta):
	if abs(velocity.x) < friction:
		velocity.x = 0
	elif velocity.x < 0:
		velocity.x += friction
	elif velocity.x > 0:
		velocity.x -= friction
	
	if not stunned:
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
	
	if not is_on_floor():
		velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_Area2D_body_entered(body):
	if body.has_method("hit"):
		body.hit(damage, global_position)

func hit(amount, from):
	velocity = (global_position - from).normalized() * knockback_strength
	stunned = true
	health -= amount
	if health < 0:
		health = 0
	
	if health <= 0:
		$CollisionShape2D.set_deferred("disabled", true)
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		velocity.y = 10
		$SFX/Die.play()
		emit_signal("die")
		$AnimationPlayer.play("die")		
		yield($AnimationPlayer, "animation_finished")
		queue_free()
	else:
		$SFX/Hit.play()
		$Timer.start()


func _on_Timer_timeout():
	stunned = false
