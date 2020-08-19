extends Node

export var first_level : PackedScene

onready var health_bar := $HUD/MarginContainer/HBoxContainer/HealthBar
onready var crystal_bar := $HUD/MarginContainer/HBoxContainer/CrystalBar

var heart_scene := preload("res://entities/Heart.tscn")
var crystal_scene := preload("res://entities/Crystal.tscn")
var mouse_cursor := preload("res://textures/target.png")
var player_scene : PackedScene = preload("res://entities/Player.tscn")
onready var player : Player = player_scene.instance()

var level : Level

func load_level(scene):
	level = scene.instance()
	
	for i in $CurrentLevel.get_children():
		$CurrentLevel.remove_child(i)
		i.queue_free()
	
	$CurrentLevel.add_child(level)
	player.global_position = level.player_spawn.global_position
	player.call_deferred("spawn")

func _ready():
	$HUD/MarginContainer.visible = false
	
	player.connect("spawn", self, "__on_Player_spawn")
	player.connect("death", self, "__on_Player_die")
	player.connect("hurt", self, "__on_Player_hurt")
	player.connect("cast", self, "__on_Player_cast")
	player.connect("health_increase", self, "__on_Player_health_increase")
	player.connect("crystals_increase", self, "__on_Player_crystals_increase")
	player.connect("change_level", self, "__on_Player_change_level")

func reset():
	player.health = player.max_health
	player.crystals = player.max_crystals
	player.global_position = level.player_spawn.global_position
	
	for child in health_bar.get_children():
		health_bar.remove_child(child)
		child.queue_free()
	
	for child in crystal_bar.get_children():
		crystal_bar.remove_child(child)
		child.queue_free()
	
	for _i in range(0, ceil(player.max_health / 2.0)):
		var heart = heart_scene.instance()
		heart.play("empty")
		health_bar.add_child(heart)
	
	for _i in range(0, ceil(player.max_crystals)):
		var crystal = crystal_scene.instance()
		crystal.play("empty")
		crystal_bar.add_child(crystal)
	
	refresh_health(player.health)
	refresh_crystals(player.crystals)

func refresh_health(health):
	if health_bar.get_child_count() > 0:
		for child in health_bar.get_children():
			child.play("empty")
		
		for i in range(0, floor(health / 2.0)):
			health_bar.get_child(i).play("full")
		
		if health % 2 != 0:
			health_bar.get_child(floor(health/2.0)).play("half")

func refresh_crystals(crystals):
	if crystal_bar.get_child_count() > 0:
		for child in crystal_bar.get_children():
			child.play("empty")
		
		for i in range(0, crystals):
			crystal_bar.get_child(i).play("full")

func __on_Player_die():
	call_deferred("restart")

func __on_Player_spawn():
	pass
#	if $AudioStreamPlayer.stream != level.music:
#		$AudioStreamPlayer.stream = level.music
#		$AudioStreamPlayer.play()

func restart():
	reset()
	player.spawn()

func __on_Player_hurt(_damage, health):
	refresh_health(health)

func __on_Player_cast(crystals):
	refresh_crystals(crystals)

func __on_Player_health_increase(health, _max_health):
	var heart = heart_scene.instance()
	heart.play("empty")
	health_bar.add_child(heart)
	
	refresh_health(health)

func __on_Player_crystals_increase(crystals, _max_crystals):
	var crystal = crystal_scene.instance()
	crystal.play("empty")
	crystal_bar.add_child(crystal)
	
	refresh_crystals(crystals)


func _on_MainMenu_start():
	add_child(player)
	player.firstSpawn = true
	load_level(first_level)
	reset()
	$HUD/MarginContainer.visible = true


func _on_MainMenu_stop():
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.stream = null
	
	for level in $CurrentLevel.get_children():
		$CurrentLevel.remove_child(level)
		level.queue_free()
	player.queue_free()
	player = player_scene.instance()

func __on_Player_change_level(new_level: PackedScene):
	call_deferred("load_level", new_level)
