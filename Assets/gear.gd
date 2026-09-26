class_name Gear
extends Resource

var type: String
var price: int
var texture: Texture2D
var strength: int
var speed: int
var snap: int
var rarity: int

func _init(data: Dictionary):
	type = data["type"]
	price = data["price"]
	texture = load(data["texture"])
	strength = data["strength"]
	speed = data["speed"]
	snap = data["snap"]
	rarity = data["rarity"]
