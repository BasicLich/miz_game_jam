extends KinematicBody2D

export var damage := 2
export var health := 100
export var knockback_strength := 300
export var friction := 10
export var max_speed := 200
export var speed := 30

var velocity := Vector2.ZERO
var stunned := false
var boost1 := false
var boost2 := false

onready var initial_health := health

func _ready():
	$AnimationPlayer.play("default")

func _physics_process(_delta):
	if abs(velocity.x) < friction:
		velocity.x = 0
	elif velocity.x < 0:
		velocity.x += friction
	elif velocity.x > 0:
		velocity.x -= friction
	
	if abs(velocity.y) < friction:
		velocity.y = 0
	elif velocity.y < 0:
		velocity.y += friction
	elif velocity.y > 0:
		velocity.y -= friction
	
	if not stunned:
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
		velocity.y = clamp(velocity.y, -max_speed, max_speed)
	
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
	
	if not boost1 and health < initial_health/2:
		boost1 = true
		speed *= 1.25
	if not boost2 and health < initial_health/4:
		boost2 = true
		speed *= 1.25
	
	if health <= 0:
		$CollisionShape2D.set_deferred("disabled", true)
		$Area2D/CollisionPolygon2D.set_deferred("disabled", true)
		$Area2D/CollisionPolygon2D2.set_deferred("disabled", true)
		$Torso/Head/Area2D/CollisionShape2D.set_deferred("disabled", true)
		queue_free()
	else:
		$Timer.start()
		$AnimationPlayer.play("hurt")
		yield($AnimationPlayer, "animation_finished")
		$AnimationPlayer.play("default")


func _on_Timer_timeout():
	stunned = false


func _on_Area2D_area_entered(area):
	if area.damage:
		hit(damage, area.global_position)
