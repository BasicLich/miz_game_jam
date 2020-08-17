extends Area2D

export var disabled := false
export var damage := 1
export var speed := 200
export var pierce := 0
var player : Node2D

func disable():
	disabled = true
	$CollisionShape2D.disabled = true
	$Sprite.visible = false

func enable():
	disabled = false
	$CollisionShape2D.disabled = false
	$Sprite.visible = true

func _physics_process(delta):
	if not disabled:
		look_at(player.global_position)
		global_position += (player.global_position - global_position).normalized() * speed * delta
		if (player.global_position - global_position).length_squared() < 8:
			get_parent().deallocate(self)


func _on_BlueBullet_body_entered(body):
	if pierce >= 0:
		pierce -= 1
		if body.has_method("hit"):
			body.hit(damage, global_position)
	if pierce < 0:
		get_parent().deallocate(self)
