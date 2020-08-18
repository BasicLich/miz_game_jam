extends Area2D

var damage := 2

func _on_Spike_body_entered(body):
	if body.has_method("hit"):
		body.hit(damage, global_position)
