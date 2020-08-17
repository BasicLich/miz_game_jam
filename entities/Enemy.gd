extends KinematicBody2D

export var damage := 1

func _ready():
	$AnimationPlayer.play("default")

func _on_Area2D_body_entered(body):
	if body.has_method("hit"):
		body.hit(damage, global_position)
