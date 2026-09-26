extends PanelContainer
class_name FishingBar

var leftmost_x_position : float = 0
var rightmost_x_position : float = 0
var absolute_center_position : Vector2 = Vector2.ZERO
var pull_amount_px : float

func get_amount_px_for_speed(speed : float)->float:
	return size.x * speed

func _on_resized() -> void:
	leftmost_x_position = global_position.x + 50
	rightmost_x_position = global_position.x + size.x - 50
	absolute_center_position = Vector2(global_position.x+(size.x/2), global_position.y+(size.y/2))
	pull_amount_px = size.x * Globals.PULL_FORCE_PERCENT
