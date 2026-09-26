extends Control

@onready var grid_container: GridContainer = $GridContainer

var items: Array[Gear] = []

var slot_scene = preload("res://Shop/Slot.tscn")

func _ready():
	var file = FileAccess.open("res://Assets/gears.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())

	for item_data in data:
		var gear := Gear.new(item_data)
		items.append(gear)

		var slot : Slot = slot_scene.instantiate()
		grid_container.add_child(slot)
		slot.setup(gear)
