extends AudioStreamPlayer

var volcano_intro : AudioStream
var volcano_loop : AudioStream

func _ready() -> void:
	volcano_intro = load("res://Assets/music/greedyfishing_volcano_intro.ogg")
	volcano_loop = load("res://Assets/music/greedyfishing_volcano_loop.ogg")

func play_habitat_music():
	if Globals.current_habitat == 0:
		play_swamp()
	elif Globals.current_habitat == 1:
		play_ice()
	elif Globals.current_habitat == 2:
		play_volcano()

func play_swamp():
	pass

func play_ice():
	pass

func play_volcano():
	stream = volcano_intro
	play()
	await finished
	stream = volcano_loop
	play()	
