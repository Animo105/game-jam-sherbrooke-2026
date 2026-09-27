extends Control


func _ready() -> void:
	MainMusic.play_lake_ambience()

func _on_quitt_button_pressed() -> void:
	get_tree().quit()

func _on_play_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed && event.button_index == MouseButton.MOUSE_BUTTON_LEFT :
		SfxManager.play("buttonclick_mainmenu")
		TransitionScreen.call_between_fade(SceneManager.load_from_file.bind(("res://Level Select/level_select.tscn")))


func _on_quit_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed && event.button_index == MouseButton.MOUSE_BUTTON_LEFT :
		get_tree().quit()
