extends TextureRect

export var emptyCrystal : Texture
export var fullCrystal : Texture

func play(name):
	match(name):
		"empty": texture = emptyCrystal
		"full": texture = fullCrystal
