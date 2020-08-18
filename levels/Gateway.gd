extends Area2D

class_name Gateway

export var next_level : PackedScene

func _ready():
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite.visible = false

func enable():
	$CollisionShape2D.set_deferred("disabled", false)
	$Sprite.visible = true

func _on_Gateway_body_entered(body):
	if body is Player:
		body.change_scene(next_level)
