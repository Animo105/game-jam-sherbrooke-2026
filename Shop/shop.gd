extends Control

@onready var grid_container: GridContainer = $GridContainer

var items: Array[Gear] = []

var slot_scene = preload("res://Shop/Slot.tscn")

@onready var hook: TextureRect = $Rig/Hook
@onready var spoon: TextureRect = $Rig/Spoon
@onready var line: TextureRect = $Rig/Line
@onready var bait: TextureRect = $Rig/Bait


func _ready():
	var file = FileAccess.open("res://Assets/gears.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())

	for item_data in data:
		var gear := Gear.new(item_data)
		items.append(gear)

		var slot : Slot = slot_scene.instantiate()
		slot.pressed.connect(slot_clicked)
		grid_container.add_child(slot)
		slot.setup(gear)

func slot_clicked(slot: Slot) -> void :
	var gear_price = slot.gear.price
	if Globals.money > gear_price :
		return
		
	slot.sold()
	Globals.money -= gear_price
		
	match slot.gear.type :
		"Bait" :
			bait.texture = slot.gear.texture
		"Spoon" :
			spoon.texture = slot.gear.texture
		"Line" :
			line.texture = slot.gear.texture
		"Hook" :
			hook.texture = slot.gear.texture
	
