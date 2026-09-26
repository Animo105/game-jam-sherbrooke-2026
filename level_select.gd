extends Node2D

@onready var stage_1: Sprite2D = $Stage1
@onready var stage_2: Sprite2D = $Stage2
@onready var stage_3: Sprite2D = $Stage3

var stages: Array
var current_stage : int = 0
var tween : Tween
var tween2 : Tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stages.append(stage_1)
	stages.append(stage_2)
	stages.append(stage_3)
	
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
		tween = create_tween()
		tween.set_parallel()
		tween.tween_property(stages[current_stage], "position:x", 1700, 1.0)
		tween.tween_property(stages[current_stage-1], "position:x", 600, 1.0)
		current_stage -= 1
	print(current_stage)

func _on_button_2_pressed() -> void:
	if current_stage != stages.size()-1:
		if tween:
			if tween.is_running():
				return
			tween.kill()
		tween = create_tween()
		tween.set_parallel()
		tween.tween_property(stages[current_stage], "position:x", -500, 1.0)
		tween.tween_property(stages[current_stage+1], "position:x", 600, 1.0)
		current_stage += 1
	print(current_stage)


func _on_select_pressed() -> void:
	pass # Replace with function body.
