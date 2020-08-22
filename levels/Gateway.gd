extends Area2D

class_name Gateway

export var next_level : PackedScene
export var start_enabled := false

func _ready():
	if not start_enabled:
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite.play("closed")
	else:
		$CollisionShape2D.set_deferred("disabled", false)
		$AnimatedSprite.play("open")

func enable():
	$CollisionShape2D.set_deferred("disabled", false)
	$AnimatedSprite.play("open")

func _on_Gateway_body_entered(body):
	if body is Player:
		body.change_scene(next_level)
