extends Resource
class_name GearResource

enum Type {
	HOOK,
	SPOON,
	LINE,
	BAIT,
	
}

@export var type : Type
@export var price : int
@export var texture : Texture2D
@export_range(0, 2, 1) var level : int
@export_range(-5,5, 1) var strenght : int
@export_range(-5,5, 1) var speed : int
@export_range(-5,5, 1) var snap : int
@export_range(-5,5, 1) var rarity : int
