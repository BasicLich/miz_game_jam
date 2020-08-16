extends TextureRect

export var emptyHeart : Texture
export var halfHeart : Texture
export var fullHeart : Texture

func play(name):
	match(name):
		"empty": texture = emptyHeart
		"half": texture = halfHeart
		"full": texture = fullHeart
