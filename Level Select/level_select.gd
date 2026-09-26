extends Node2D

@onready var select_button: Button = $SelectButton
@onready var fish_display: HFlowContainer = $FishDisplay
@onready var boat: Sprite2D = $Boat

var stages: Array
var tween : Tween

var center_screen : Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen = get_window().size/2.0
	center_screen.y -= 75
	display_fishes()
	boat.position = Vector2(center_screen.x,center_screen.y * 1.8)
	var values : = LevelManager.level_list.values()
	values.sort_custom(
		func(a : LevelRessource, b : LevelRessource) -> bool:
			return a.id < b.id
	)
	for level : LevelRessource in values:
		var level_sprite : Sprite2D = Sprite2D.new()
		level_sprite.texture = level.texture if level.is_unlocked else level.hidden_texture
		if level.id == 0:
			level_sprite.position = center_screen
		else:
			level_sprite.position = Vector2(center_screen.x * 3,center_screen.y)
		stages.append(level_sprite)
		add_child(level_sprite)

	
func _input(event: InputEvent) -> void:
	if event.is_action("left"):
		_on_button_pressed()
	if event.is_action("right"):
		_on_button_2_pressed()

func _on_button_pressed() -> void:
	if Globals.current_habitat != 0:
		if tween:
			if tween.is_running():
				return
			tween.kill()
		if !LevelManager.level_list[Globals.current_habitat-1].is_unlocked:
			select_button.text = str(LevelManager.level_list[Globals.current_habitat-1].cost) + "$"
		else:
			select_button.text = "select"
		tween = create_tween()
		tween.set_parallel()
		tween.set_trans(Tween.TRANS_BACK)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(stages[Globals.current_habitat], "position:x", center_screen.x * 3, 2.0)
		tween.tween_property(stages[Globals.current_habitat-1], "position:x", center_screen.x, 2.5)
		Globals.current_habitat -= 1
		for child in fish_display.get_children():
			fish_display.remove_child(child)
		#await tween.finished
		display_fishes()
	print(Globals.current_habitat)

func _on_button_2_pressed() -> void:
	if Globals.current_habitat != stages.size()-1:
		if tween:
			if tween.is_running():
				return
			tween.kill()
		if !LevelManager.level_list[Globals.current_habitat+1].is_unlocked:
			select_button.text = str(LevelManager.level_list[Globals.current_habitat+1].cost) + "$"
		else:
			select_button.text = "select"
		tween = create_tween()
		tween.set_parallel()
		tween.set_trans(Tween.TRANS_BACK)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(stages[Globals.current_habitat], "position:x", center_screen.x * -1.5, 2.5)
		tween.tween_property(stages[Globals.current_habitat+1], "position:x", center_screen.x, 2.0)
		Globals.current_habitat += 1
		for child in fish_display.get_children():
			fish_display.remove_child(child)
		#await tween.finished
		display_fishes()
	print(Globals.current_habitat)


func _on_select_pressed() -> void:
	if LevelManager.level_list[Globals.current_habitat].is_unlocked:
		pass # instert transition here
	else :
		if LevelManager.level_list[Globals.current_habitat].cost < Globals.money:
			Globals.money -= LevelManager.level_list[Globals.current_habitat].cost
			LevelManager.level_list[Globals.current_habitat].is_unlocked = true
			stages[Globals.current_habitat].texture = LevelManager.level_list[Globals.current_habitat].texture

func display_fishes() -> void:
	for x : FishResource in FishManager.fish_list.values():
		if x.habitat == Globals.current_habitat:
			print("here")
			var fish_display_texture : TextureRect = TextureRect.new()
			fish_display_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			if x.seen:
				fish_display_texture.texture = x.texture
			else:
				fish_display_texture.texture = x.hidden_texture
			fish_display_texture.custom_minimum_size = Vector2(64,64)
			fish_display.add_child(fish_display_texture)
	fish_display.position = Vector2(400, -500)
	tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(fish_display, "position:y", 50, 2.0)
