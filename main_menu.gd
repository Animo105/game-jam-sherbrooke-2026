extends Control


func _ready() -> void:
	MainMusic.play_lake_ambience()

func _on_play_button_pressed() -> void:
	SfxManager.play("buttonclick_mainmenu")
	TransitionScreen.call_between_fade(SceneManager.load_from_file.bind(("res://Level Select/level_select.tscn")))


func _on_quitt_button_pressed() -> void:
	get_tree().quit()

func _on_button_mouse_entered() -> void:
	SfxManager.play("buttonhover2", -2, randf_range(0.75, 1.25))
