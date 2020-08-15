extends Node

export var first_level : PackedScene

func _ready():
	reset()

func reset():
	for level in $CurrentLevel.get_children():
		$CurrentLevel.remove_child(level)
		level.queue_free()
	
	var level = first_level.instance()
	$CurrentLevel.add_child(level)
	level.get_node("Player").connect("death", self, "__on_Player_die")

func __on_Player_die():
	reset()
