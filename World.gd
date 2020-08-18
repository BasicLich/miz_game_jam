extends Level

func _ready():
	gateway.enable()
	gateway.next_level = load("res://levels/Level0.tscn")
