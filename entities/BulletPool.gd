extends Node

export var bullet : PackedScene = preload("res://entities/BlueBullet.tscn")
export var initial_pool_size := 128
export var pool_grow_size := 32

var unallocated := []
var allocated := []

func _ready():
	for i in range (0, initial_pool_size):
		var instance = bullet.instance()
		instance.disable()
		add_child(instance)
		unallocated.append(instance)

func allocate() -> Area2D:
	if unallocated.empty():
		for i in range(0, pool_grow_size):
			var instance = bullet.instance()
			instance.disable()
			add_child(instance)
			unallocated.append(instance)
	var instance = unallocated.pop_back()
	allocated.append(instance)
	instance.enable()
	return instance

func deallocate(instance):
	instance.disable()
	allocated.remove(allocated.find(instance))
	unallocated.append(instance)