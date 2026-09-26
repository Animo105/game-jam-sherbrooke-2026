extends Control

@onready var grid_container: GridContainer = $GridContainer

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

@onready var money_label: Label = %MoneyLabel

var frames: Array[Texture2D] = []
var frame_index: int = 0

func _set_animation():
	var level = LevelManager.level_list[Globals.current_habitat]
	frames = level.shop_frames
	if frames == []: return
	var timer := Timer.new()
	timer.wait_time = 0.5
	texture_rect.texture = frames[0]
	timer.timeout.connect(func():
		frame_index = (frame_index + 1) % frames.size()
		texture_rect.texture = frames[frame_index]
	)
	add_child(timer)
	timer.start()

func _ready():
	_set_animation()
	money_label.text = str(Globals.money)
	set_actives_slots()
	if Globals.rod.bait_gear:
		bait.texture = Globals.rod.bait_gear.texture
	if Globals.rod.spoon_gear:
		spoon.texture = Globals.rod.spoon_gear.texture
	if Globals.rod.line_gear:
		line.texture = Globals.rod.line_gear.texture
	if Globals.rod.hook_gear:
		hook.texture  = Globals.rod.hook_gear.texture
	
	# pick stuff
	var hooks : Array = GearManager.hook_list.duplicate()
	var gear : GearResource = null
	for i in range(3):
		gear = hooks.pick_random()
		if gear == null: break
		hooks.erase(gear)
		create_slot(gear)
	var spoons : Array = GearManager.spoon_list.duplicate()
	for i in range(3):
		gear = spoons.pick_random()
		if gear == null: break
		spoons.erase(gear)
		create_slot(gear)
	var lines : Array = GearManager.line_list.duplicate()
	for i in range(3):
		gear = lines.pick_random()
		if gear == null: break
		lines.erase(gear)
		create_slot(gear)

	bait_bucket.pressed.connect(bucket_clicked)
	bait_bucket_2.pressed.connect(bucket_clicked)
	bait_bucket_3.pressed.connect(bucket_clicked)

func create_slot(gear : GearResource):
	var slot : Slot = slot_scene.instantiate()
	slot.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	slot.pressed.connect(slot_clicked)
	slot.on_mouse_entered.connect(slot_enter_hover)
	slot.on_mouse_exited.connect(slot_exit_hover)
	grid_container.add_child(slot)
	slot.setup(gear)

func bucket_clicked(bucket: BaitBucket) :
	buy_and_set(bucket.setup_gear)

func slot_clicked(slot: Slot) -> void :
	if buy_and_set(slot.gear):
		set_actives_slots()
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
	if Globals.money < gear_price :
		return false
	Globals.money -= gear_price
	money_label.text = str(Globals.money)
	match gear.type :
		GearResource.Type.BAIT :
			Globals.rod.bait_gear = gear
			bait.texture = gear.texture
		GearResource.Type.SPOON :
			Globals.rod.spoon_gear = gear
			spoon.texture = gear.texture
		GearResource.Type.LINE :
			Globals.rod.line_gear = gear
			line.texture = gear.texture
		GearResource.Type.HOOK :
			Globals.rod.hook_gear = gear
			hook.texture = gear.texture
	return true

func set_actives_slots():
	Globals.rod.calculate_stats()
	strength.active_slots = Globals.rod.pull_strenght
	speed.active_slots = Globals.rod.catch_speed
	snap.active_slots = Globals.rod.snap_resistence

func _on_next_button_pressed() -> void:
	Globals.rod.calculate_stats()
	TransitionScreen.call_between_fade(SceneManager.load_from_file.bind("res://Main Fish Phase/main_fish_phase.tscn"))
