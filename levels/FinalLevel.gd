extends Level

signal game_won
signal play_music

export var win_music : AudioStream

func _on_Boss_dying():
	emit_signal("play_music", win_music)

func _on_Boss_die():
	emit_signal("game_won")
