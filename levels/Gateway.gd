extends Area2D

class_name Gateway

signal change_level

export var next_level : PackedScene

func _ready():
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite.visible = false

func enable():
	$CollisionShape2D.set_deferred("disabled", false)
	$Sprite.visible = true

func _on_Gateway_body_entered(body):
	print("Gateway")
	if body is Player:
		print("PLAYER!")
		emit_signal("change_level", next_level)
