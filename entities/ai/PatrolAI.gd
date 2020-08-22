extends Node2D

export var facing_left := false
export var chance_change := 0.0

var spawning := true

func _physics_process(_delta):
	if not spawning:
		if chance_change > 0:
			if chance_change < randf():
				facing_left = !facing_left
			scale.x *= -1
		
		if $WallCheck.is_colliding() or (not $FallCheck.is_colliding() and not $FallCheck2.is_colliding()):
			facing_left = !facing_left
			scale.x *= -1
		
		if not get_parent().stunned:
			if facing_left:
				get_parent().velocity.x -= get_parent().speed
			else:
				get_parent().velocity.x += get_parent().speed

func _on_Timer_timeout():
	spawning = false
