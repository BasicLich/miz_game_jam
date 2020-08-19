extends KinematicBody2D

class_name Player

signal spawn
signal death
signal hurt(damage, health)
signal cast(crystals)
signal health_increase(health, max_health)
signal crystals_increase(crystals, max_crystals)
signal change_level(level)

export var crystal_tower : PackedScene = preload("res://entities/CrystalTower.tscn")

export var max_health := 6
export var health : int = max_health
export var max_crystals := 0
export var crystals : int = max_crystals

export var firstSpawn := true

export var speed := 150
export var gravity := 20
export var max_fall_speed := 400
export var jump_impulse := 400

export var double_jump_impulse := 400
export var can_double_jump := true

var velocity := Vector2.ZERO
var stunned := false
var loading := true
var dying := false
var jumped := false
var double_jumped := false

func _ready():
	$Spawn.visible = false

func spawn():
	$AnimatedSprite.scale = Vector2(1, 1)
	stunned = false
	velocity = Vector2.ZERO
	loading = true
	dying = false
	jumped = false
	double_jumped = false
	$AnimatedSprite.play("default")
	$Knockback.stop()
	$ShootCooldown.stop()
	$BulletPool.refresh()
	for child in $CrystalTowers.get_children():
		child.queue_free()
	
	if firstSpawn:
		$AnimationPlayer.play("Spawn")
		firstSpawn = false
	else:
		$AnimationPlayer.play("Respawn")
	
	$Camera2D.align()
	$Camera2D.smoothing_enabled = true

func _physics_process(_delta):
	if loading or dying:
		return
	
	if Input.is_action_just_pressed("down"):
		set_collision_mask_bit(5, false)
	elif Input.is_action_just_released("down"):
		set_collision_mask_bit(5, true)
	
	if Input.is_action_pressed("cast") and crystals > 0 and $ShootCooldown.is_stopped():
		crystals -= 1
		emit_signal("cast", crystals)
		var instance = crystal_tower.instance()
		instance.global_position = global_position
		instance.player = self
		$CrystalTowers.add_child(instance)
		$ShootCooldown.start()
	
	if Input.is_action_pressed("attack") and $ShootCooldown.is_stopped():
		var instances = []
		for tower in $CrystalTowers.get_children():
			var i = $BulletPool.allocate()
			i.global_position = tower.global_position
			instances.append(i)
		if not instances.empty():
			$ShootCooldown.start()
			$SFX/Shoot.play()
		for i in instances:
			i.look_at(self.global_position)
			i.player = self
	
	if double_jumped and $GroundCheck.is_colliding():
		double_jumped = false
	
	var direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	var jump = Input.is_action_just_pressed("jump") and $GroundCheck.is_colliding()
	var double_jump = can_double_jump and Input.is_action_just_pressed("jump") and not $GroundCheck.is_colliding() and not double_jumped
	
	if direction < 0:
		$AnimatedSprite.flip_h = true
	elif direction > 0:
		$AnimatedSprite.flip_h = false
	
	if stunned:
		$AnimatedSprite.play("hurt")
		$SFX/Hurt.play()
		$AnimationPlayer.stop()
	elif not is_on_floor():
		$AnimatedSprite.play("fall")
		$AnimationPlayer.stop()
	elif direction == 0:
		$AnimatedSprite.play("default")
		$AnimationPlayer.stop()
	else:
		$AnimatedSprite.play("run")
		$AnimationPlayer.play("Walking")
	
	if not stunned:
		velocity.x = direction * speed
		if jump:
			velocity.y = -jump_impulse
			$SFX/Jump.play()
		elif double_jump:
			double_jumped = true
			velocity.y = -double_jump_impulse
			$SFX/Jump.play()
		else:
			velocity.y = clamp(velocity.y + gravity, -max_fall_speed, max_fall_speed)
	else:
		velocity.y = clamp(velocity.y + gravity, -max_fall_speed, max_fall_speed)
	
	if is_on_floor():
		velocity = move_and_slide_with_snap(velocity, Vector2(0, 3), Vector2.UP)
	else:
		velocity = move_and_slide(velocity, Vector2.UP)
		if is_on_floor():
			$SFX/Land.play()

func restore_crystal():
	crystals += 1
	if crystals > max_crystals:
		crystals = max_crystals
	emit_signal("cast", crystals)

func hit(damage, from):
	print("hurt: " + str(damage) + " " + str(from))
	health -= damage
	if health < 0: 
		health = 0
	emit_signal("hurt", damage, health)
	if health <= 0:
		dying = true
		$AnimationPlayer.play("Die")
	else:
		stunned = true
		$Knockback.start()
		velocity = (global_position - from).normalized()
		velocity.x *= speed
		velocity.y *= jump_impulse
		$AnimatedSprite.play("hurt")

func _on_Knockback_timeout():
	stunned = false

func _on_AnimationPlayer_animation_finished(anim_name):
	match(anim_name):
		"Spawn":
			loading = false
		"Respawn":
			loading = false
		"Die":
			emit_signal("death")

func increment_hearts():
	max_health += 2
	health += 2
	emit_signal("health_increase", health, max_health)

func increment_crystals():
	max_crystals += 1
	crystals += 1
	emit_signal("crystals_increase", crystals, max_crystals)

func heal(amount):
	health += amount
	if health > max_health:
		health = max_health
	emit_signal("hurt", -1, health)

func change_scene(next_level):
	stunned = false
	velocity = Vector2.ZERO
	loading = true
	dying = false
	jumped = false
	double_jumped = false
	$AnimatedSprite.play("default")
	$AnimationPlayer.stop()
	$Knockback.stop()
	$ShootCooldown.stop()
	$BulletPool.refresh()
	for child in $CrystalTowers.get_children():
		child.queue_free()
	$AnimationPlayer.play("Leave")
	yield($AnimationPlayer, "animation_finished")
	$Camera2D.smoothing_enabled = false
	$Camera2D.align()
	emit_signal("change_level", next_level)
