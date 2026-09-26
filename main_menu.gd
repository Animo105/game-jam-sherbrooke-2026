extends Control




func _on_play_button_pressed() -> void:
	TransitionScreen.call_between_fade(SceneManager.load_from_file.bind(("res://Level Select/level_select.tscn")))
	


func _on_quitt_button_pressed() -> void:
	get_tree().quit()
