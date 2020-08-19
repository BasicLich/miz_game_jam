extends TileMap

export var cancelBulletCollider : PackedScene
export var cancelCrystalCollider : PackedScene

func _ready():
	var cancelBulletId = tile_set.find_tile_by_name("CancelBullet")
	for vector in get_used_cells_by_id(cancelBulletId):
		var collider: Area2D = cancelBulletCollider.instance()
		collider.global_position = map_to_world(vector)
		add_child(collider)
	
	var cancelCrystalId = tile_set.find_tile_by_name("CancelCrystal")
	for vector in get_used_cells_by_id(cancelCrystalId):
		var collider: Area2D = cancelCrystalCollider.instance()
		collider.global_position = map_to_world(vector)
		add_child(collider)
