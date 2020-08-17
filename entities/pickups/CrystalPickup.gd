extends Area2D

func _ready():
	$AnimationPlayer.play("default")


func _on_CrystalPickup_body_entered(body):
	if body.has_method("increment_crystals"):
		body.increment_crystals()
		queue_free()
