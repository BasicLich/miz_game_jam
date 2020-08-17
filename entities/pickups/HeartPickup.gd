extends Area2D

func _ready():
	$AnimationPlayer.play("default")


func _on_HeartPickup_body_entered(body):
	if body.has_method("increment_hearts"):
		body.increment_hearts()
		queue_free()
