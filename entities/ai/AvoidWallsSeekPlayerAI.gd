extends Node

export var navigation: NodePath 
onready var nav: Navigation2D = get_node(navigation)
onready var player: Player = get_node("/root/Game/Player")

var path : PoolVector2Array = []

func _ready():
	set_physics_process(false)

func _physics_process(_delta):
	if not get_parent().stunned and path and not path.empty():
		var distance = get_parent().speed
		var start_point : Vector2 = get_parent().position
		for _i in range(path.size()):
			var distance_to_next := start_point.distance_to(path[0])
			if distance <= distance_to_next and distance >= 0.0:
				get_parent().velocity += (path[0] - get_parent().position) * (distance / distance_to_next)
				break
			distance -= distance_to_next
			start_point = path[0]
			path.remove(0)

func _on_Timer_timeout():
	path = nav.get_simple_path(get_parent().global_position, player.global_position)
	if $Timer2.is_stopped() and get_parent().velocity == Vector2.ZERO:
		$Timer2.start()


func _on_Area2D_body_entered(body):
	if body is Player:
		set_physics_process(true)
		$Timer.start()


func _on_Timer2_timeout():
	if get_parent().velocity == Vector2.ZERO:
		get_parent().velocity = (get_parent().global_position - player.global_position).normalized() * get_parent().knockback_strength
