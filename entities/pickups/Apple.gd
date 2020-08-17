extends Area2D

export var health := 1

func _on_Apple_body_entered(body):
	if body.has_method("heal"):
		body.heal(health)
		queue_free()
