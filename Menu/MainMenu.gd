extends Control

signal start
signal stop

var game_running := false

func _ready():
	$AnimationPlayer.play("default")

func _physics_process(delta):
	if not game_running:
		if Input.is_action_just_pressed("ui_accept"):
			visible = false
			game_running = true
			emit_signal("start")
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().quit(0)
	else:
		if Input.is_action_just_pressed("ui_cancel"):
			visible = true
			game_running = false
			emit_signal("stop")
