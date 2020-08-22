extends Control

signal start
signal stop

export var title_music : AudioStream

var game_running := false

func _ready():
	$AnimationPlayer.play("default")
	get_node("../AudioStreamPlayer").stream = title_music
	get_node("../AudioStreamPlayer").play()

func _physics_process(_delta):
	if not game_running:
		if Input.is_action_just_pressed("ui_accept"):
			visible = false
			game_running = true
			emit_signal("start")
			get_node("../AudioStreamPlayer").stop()
		if Input.is_action_just_pressed("ui_cancel"):
			get_node("../AudioStreamPlayer").stop()
			get_tree().quit(0)
	else:
		if Input.is_action_just_pressed("ui_cancel"):
			visible = true
			game_running = false
			emit_signal("stop")
			$AudioStreamPlayer.stream = title_music
			$AudioStreamPlayer.play()
