extends RigidBody2D

signal die

export var damage := 2
export var health := 3
export var knockback_strength := 300

#var velocity := Vector2.ZERO
var stunned := false

func _ready():
	$AnimationPlayer.play("default")

func _on_Area2D_body_entered(body):
	if body.has_method("hit"):
		body.hit(damage, global_position)

func hit(amount, from):
	if health <= 0:
		return
	apply_impulse(from, Vector2(knockback_strength, 0))
	stunned = true
	health -= amount
	if health < 0:
		health = 0
	
	if health <= 0:
		$CollisionShape2D.set_deferred("disabled", true)
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
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
