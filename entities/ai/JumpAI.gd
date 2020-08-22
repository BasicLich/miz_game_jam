extends Node2D

var jump_strength := 200

func _on_Timer_timeout():
	if $GroundCheck.is_colliding():
		get_parent().velocity.y = -jump_strength
		get_parent().velocity.x = (randf()-0.5) * (jump_strength*4)
