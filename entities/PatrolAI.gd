extends Node2D

export var facing_left := false

var spawning := true

func _physics_process(delta):
	if not spawning:
		if $WallCheck.is_colliding() or not $FallCheck.is_colliding():
			print(str(facing_left) + " " + str(global_position) + " " + str($WallCheck.is_colliding()) + " " + str($FallCheck.is_colliding()))
			facing_left = !facing_left
			scale.x *= -1
		
		if facing_left:
			get_parent().velocity.x -= get_parent().speed
		else:
			get_parent().velocity.x += get_parent().speed

func _on_Timer_timeout():
	spawning = false
