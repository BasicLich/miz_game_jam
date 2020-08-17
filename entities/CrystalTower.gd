extends Node2D

var player

func _on_Timer_timeout():
	player.restore_crystal()
	queue_free()
