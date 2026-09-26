extends Control

@onready var grid_container: GridContainer = $GridContainer

@export var Gears: Array[GearResource] = []

var slot_scene = preload("res://Shop/Slot.tscn")

@onready var texture_rect: TextureRect = $TextureRect

@onready var spoon: TextureRect = $Equipment/VBoxContainer2/Spoon
@onready var hook: TextureRect = $Equipment/VBoxContainer2/Hook
@onready var bait: TextureRect = $Equipment/VBoxContainer2/Bait
@onready var line: TextureRect = $Equipment/VBoxContainer2/Line



@onready var bait_bucket: BaitBucket = $Baits/BaitBucket
@onready var bait_bucket_2: BaitBucket = $Baits/BaitBucket2
@onready var bait_bucket_3: BaitBucket = $Baits/BaitBucket3


@onready var strength: PowerBar = $Equipment/VBoxContainer/Strength
@onready var snap: PowerBar = $Equipment/VBoxContainer/Snap
@onready var speed: PowerBar = $Equipment/VBoxContainer/Speed

@export var frames: Array[Texture2D] = []
var frame_index: int = 0


func _ready():
	for gear in Gears:
		var slot : Slot = slot_scene.instantiate()
		slot.pressed.connect(slot_clicked)
		slot.on_mouse_entered.connect(slot_enter_hover)
		slot.on_mouse_exited.connect(slot_exit_hover)
		
		bait_bucket.pressed.connect(bucket_clicked)
		bait_bucket_2.pressed.connect(bucket_clicked)
		bait_bucket_3.pressed.connect(bucket_clicked)
		
		grid_container.add_child(slot)
		slot.setup(gear)
		
	var timer := Timer.new()
	timer.wait_time = 0.5
	timer.timeout.connect(func():
		texture_rect.texture = frames[frame_index]
		frame_index = 1 if frame_index == 0 else 0
	)
	add_child(timer)
	timer.start()

func bucket_clicked(bucket: BaitBucket) :
	buy_and_set(bucket.setup_gear)

func slot_clicked(slot: Slot) -> void :
	if buy_and_set(slot.gear):
		grid_container.remove_child(slot)
		
func slot_enter_hover(slot: Slot) -> void :
	strength.preview_slots = slot.gear.strenght
	speed.preview_slots = slot.gear.speed
	snap.preview_slots = slot.gear.snap
	
func slot_exit_hover(slot: Slot) -> void :
	strength.preview_slots = 0
	speed.preview_slots = 0
	snap.preview_slots = 0


func buy_and_set(gear : GearResource) -> bool:
	var gear_price = gear.price
	if Globals.money > gear_price :
		return false
	
	Globals.money -= gear_price
		
	match gear.type :
		GearResource.Type.BAIT :
			bait.texture = gear.texture
		GearResource.Type.SPOON :
			spoon.texture = gear.texture
		GearResource.Type.LINE :
			line.texture = gear.texture
		GearResource.Type.HOOK :
			hook.texture = gear.texture
	return true
	
	
	
