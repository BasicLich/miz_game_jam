extends TileMap

var spikeCollider : PackedScene = preload("res://tilesets/tiles/Spike.tscn")

func _ready():
	var id = tile_set.find_tile_by_name("Spikes")
	for vector in get_used_cells_by_id(id):
		var collider: Area2D = spikeCollider.instance()
		collider.global_position = map_to_world(vector)
		add_child(collider)
