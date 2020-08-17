extends Node2D

var player

func _ready():
	$AnimationPlayer.play("default")

func expire():
	player.restore_crystal()
	queue_free()
