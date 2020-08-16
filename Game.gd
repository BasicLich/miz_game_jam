extends Node

export var first_level : PackedScene

var heart_scene := preload("res://Heart.tscn")
var player

func _ready():
	reset()

func reset():
	for level in $CurrentLevel.get_children():
		$CurrentLevel.remove_child(level)
		level.queue_free()
	
	var level = first_level.instance()
	$CurrentLevel.add_child(level)
	
	player = level.get_node("Player")
	
	player.connect("death", self, "__on_Player_die")
	player.connect("hurt", self, "__on_Player_hurt")
	
	for child in $HUD/MarginContainer/HealthBar.get_children():
		$HUD/MarginContainer/HealthBar.remove_child(child)
		child.queue_free()
	
	for i in range(0, ceil(player.max_health / 2.0)):
		var heart = heart_scene.instance()
		heart.play("empty")
		$HUD/MarginContainer/HealthBar.add_child(heart)
	
	refresh_health()

func refresh_health():
	if $HUD/MarginContainer/HealthBar.get_child_count() > 0:
		for child in $HUD/MarginContainer/HealthBar.get_children():
			child.play("empty")
		
		for i in range(0, floor(player.health / 2.0)):
			$HUD/MarginContainer/HealthBar.get_child(i).play("full")
		
		if player.health % 2 != 0:
			$HUD/MarginContainer/HealthBar.get_child(floor(player.health/2.0)).play("half")

func __on_Player_die():
	call_deferred("reset")

func __on_Player_hurt(damage, health):
	if health > 0:
		refresh_health()
