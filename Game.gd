extends Node

export var first_level : PackedScene

onready var health_bar := $HUD/MarginContainer/HBoxContainer/HealthBar
onready var crystal_bar := $HUD/MarginContainer/HBoxContainer/CrystalBar

var heart_scene := preload("res://entities/Heart.tscn")
var crystal_scene := preload("res://entities/Crystal.tscn")
var mouse_cursor := preload("res://textures/target.png")
var player

func _ready():
	Input.set_custom_mouse_cursor(mouse_cursor, 0, Vector2(16, 16))
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
	player.connect("cast", self, "__on_Player_cast")
	
	for child in health_bar.get_children():
		health_bar.remove_child(child)
		child.queue_free()
	
	for child in crystal_bar.get_children():
		crystal_bar.remove_child(child)
		child.queue_free()
	
	for i in range(0, ceil(player.max_health / 2.0)):
		var heart = heart_scene.instance()
		heart.play("empty")
		health_bar.add_child(heart)
	
	for i in range(0, ceil(player.max_crystals)):
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
	call_deferred("reset")

func __on_Player_hurt(damage, health):
	refresh_health(health)

func __on_Player_cast(crystals):
	refresh_crystals(crystals)
