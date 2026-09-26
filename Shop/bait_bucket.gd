extends Control

@export var frames: Array[Texture2D] = []
@export var fps: float = 2

var frame_index: int = 0
var time: float = 0.0

@onready var texture_rect: TextureRect = $TextureRect


func _ready() -> void:
	if frames.is_empty():
		return
	texture_rect.texture = frames[0]


func _process(delta: float) -> void:
	if frames.size() <= 1:
		return

	time += delta

	if time >= 1.0 / fps:
		time -= 1.0 / fps

		frame_index = (frame_index + 1) % frames.size()
		texture_rect.texture = frames[frame_index]
