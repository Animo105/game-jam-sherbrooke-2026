extends HBoxContainer
class_name SkillBar

@export var texture : Texture2D

@onready var texture_rect: TextureRect = $TextureRect
@onready var actual_value_label: Label = $ActualValueLabel
@onready var preview_value_label: Label = $PreviewValueLabel

const POSITIVE_FONT_COLOR : Color = Color.WEB_GREEN
const NEGATIVE_FONT_COLOR : Color = Color.DARK_RED

var preview_value : float = 0 : set = set_preview_value
var actual_value : float = 0 : set = set_actual_value

func _ready() -> void:
	texture_rect.texture = texture
	preview_value_label.visible = false
	actual_value_label.text = "0"

func set_preview_value(value : float):
	preview_value = value
	var diff = preview_value - actual_value
	var string : String = ""
	if diff < 0:
		preview_value_label.set("theme_override_colors/font_color", NEGATIVE_FONT_COLOR)
		string = "-"
	else:
		preview_value_label.set("theme_override_colors/font_color", POSITIVE_FONT_COLOR)
		string = "+"
	diff = abs(diff)
	string += "%2.f (%2.f)" % [diff, preview_value]
	preview_value_label.text = string
	preview_value_label.visible = true

func hide_preview():
	preview_value_label.visible = false

func set_actual_value(value : float):
	actual_value = value
	actual_value_label.text = "%2.f" % actual_value
