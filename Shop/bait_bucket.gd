class_name BaitBucket
extends Control

signal pressed(bucket :BaitBucket)

@export var frames: Array[Texture2D] = []
@export var setup_gear: GearResource

var fps: float = 2
var frame_index: int = 0
var time: float = 0.0

@onready var texture_rect: TextureRect = $TextureRect
@onready var tag: PriceTag = $TextureRect/Tag

func _ready() -> void:
	texture_rect.texture = frames[0]
	tag.setup(setup_gear)

func _process(delta: float) -> void:
	if frames.size() <= 1:
		return

	time += delta

	if time >= 1.0 / fps:
		time -= 1.0 / fps

		frame_index = (frame_index + 1) % frames.size()
		texture_rect.texture = frames[frame_index]


func _on_mouse_entered() -> void:
	var tween := create_tween() \
		.set_parallel(true) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(texture_rect, "rotation", deg_to_rad(-7), 0.15)


func _on_mouse_exited() -> void:
	var tween := create_tween() \
		.set_parallel(true) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(texture_rect, "rotation", 0.0, 0.15)


func _on_texture_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed && event.button_index == MouseButton.MOUSE_BUTTON_LEFT :
		pressed.emit(self)
