extends Area2D

export var damage := 1
export var speed := 200
export var pierce := 0
var player : Node2D

func _physics_process(delta):
	look_at(player.global_position)
	global_position += (player.global_position - global_position).normalized() * speed * delta
	if (player.global_position - global_position).length_squared() < 8:
		queue_free()


func _on_BlueBullet_body_entered(body):
	if pierce >= 0:
		pierce -= 1
		if body.has_method("hit"):
			body.hit(damage, global_position)
	if pierce < 0:
		queue_free()
