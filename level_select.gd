extends Node2D

@onready var swamp: Sprite2D = $Swamp
@onready var frozen: Sprite2D = $Frozen
@onready var volcano: Sprite2D = $Volcano
@onready var select_button: Button = $SelectButton
@onready var fish_display: HFlowContainer = $FishDisplay

var stages: Array
var current_stage : int = 0
var tween : Tween
var tween2 : Tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	display_fishes()
	stages.append(swamp)
	stages.append(frozen)
	stages.append(volcano)
	
func _input(event: InputEvent) -> void:
	if event.is_action("left"):
		_on_button_pressed()
	if event.is_action("right"):
		_on_button_2_pressed()

func _on_button_pressed() -> void:
	if current_stage != 0:
		if tween:
			if tween.is_running():
				return
			tween.kill()
		if !Globals.level_unlocked.has(current_stage-1):
			select_button.text = "locked"
		else:
			select_button.text = "select"
		tween = create_tween()
		tween.set_parallel()
		tween.set_trans(Tween.TRANS_BACK)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(stages[current_stage], "position:x", 1700, 2.0)
		tween.tween_property(stages[current_stage-1], "position:x", 600, 2.0)
		current_stage -= 1
		for child in fish_display.get_children():
			fish_display.remove_child(child)
		#await tween.finished
		display_fishes()
	print(current_stage)

func _on_button_2_pressed() -> void:
	if current_stage != stages.size()-1:
		if tween:
			if tween.is_running():
				return
			tween.kill()
		if !Globals.level_unlocked.has(current_stage+1):
			select_button.text = "locked"
		else:
			select_button.text = "select"
		tween = create_tween()
		tween.set_parallel()
		tween.set_trans(Tween.TRANS_BACK)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(stages[current_stage], "position:x", -500, 2.0)
		tween.tween_property(stages[current_stage+1], "position:x", 600, 2.0)
		current_stage += 1
		for child in fish_display.get_children():
			fish_display.remove_child(child)
		#await tween.finished
		display_fishes()
	print(current_stage)


func _on_select_pressed() -> void:
	pass # Replace with function body.

func display_fishes() -> void:
	for x : FishResource in FishManager.fish_list.values():
		if x.habitat == current_stage:
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
