extends Node2D

class_name Level

signal enemy_died(remaining, total)

export var music : AudioStream

onready var gateway : Gateway = $Gateway
onready var player_spawn : Position2D = $PlayerSpawn

onready var total_enemies : int = $Enemies.get_child_count()
onready var remaining_enemies : int = total_enemies

func _ready():
	for enemy in $Enemies.get_children():
		enemy.connect("die", self, "__on_Enemy_die")

func __on_Enemy_die():
	remaining_enemies -= 1
	if remaining_enemies < 0:
		remaining_enemies = 0
	emit_signal("enemy_died", remaining_enemies, total_enemies)
	if remaining_enemies <= 0:
		gateway.enable()
