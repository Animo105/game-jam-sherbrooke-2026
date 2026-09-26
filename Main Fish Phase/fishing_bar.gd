extends PanelContainer
class_name FishingBar

const CATCH_ZONE_SIZE : float = 0.10

@onready var texture_rect: TextureRect = $TextureRect

var leftmost_x_position : float = 0
var rightmost_x_position : float = 0
var absolute_center_position : Vector2 = Vector2.ZERO
var pull_amount_px : float

func get_amount_px_for_speed(speed : float)->float:
	return size.x * speed

func get_distance_from_center_in_percent(x : float)-> float:
	return abs(x - absolute_center_position.x) / (rightmost_x_position - leftmost_x_position)

func is_inside_zone(x : float) -> bool:
	var distance = get_distance_from_center_in_percent(x)
	return distance < (CATCH_ZONE_SIZE + 0.05)/2

func _on_resized() -> void:
	leftmost_x_position = global_position.x + 50
	rightmost_x_position = global_position.x + size.x - 50
	absolute_center_position = Vector2(global_position.x+(size.x/2), global_position.y+(size.y/2))
	pull_amount_px = size.x * Globals.PULL_FORCE_PERCENT
	if texture_rect:
		texture_rect.custom_minimum_size = Vector2(size.x * CATCH_ZONE_SIZE, size.y)
