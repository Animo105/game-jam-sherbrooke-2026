class_name Slot
extends Control

signal pressed(slot)


@onready var item: TextureRect = $Item
@onready var shadow: TextureRect = $Shadow

@onready var tag: TextureRect = $Tag
@onready var price: Label = $Tag/Price

@onready var tag_big: TextureRect = $TagBig
@onready var price_big: Label = $TagBig/Price

@onready var tag_small: TextureRect = $TagSmall
@onready var price_small: Label = $TagSmall/Price

var active_tag: TextureRect
var gear : Gear

func sold() -> void:
	var price = active_tag.get_child(0)
	price.text = "sold"
	price.add_theme_color_override("font_color", "FF0000")

func setup(setup_gear: Gear) -> void:
	gear = setup_gear
	
	item.texture = gear.texture

	tag.hide()
	tag_big.hide()
	tag_small.hide()

	var price_string := str(gear.price)

	match price_string.length():
		1, 2:
			active_tag = tag_small
		3:
			active_tag = tag
		_:
			active_tag = tag_big

	active_tag.show()
	var price = active_tag.get_child(0)
	price.text = "%d$" % gear.price

func _process(delta: float) -> void:
	var value = sin(Time.get_ticks_msec() * 0.0015)
	item.position.y = value * 5.0
	
	value = value * 0.1 + 0.8
	shadow.scale = Vector2(value, value)


func _on_mouse_entered() -> void:	
	var tween := create_tween() \
		.set_parallel(true) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(item, "rotation", deg_to_rad(10), 0.15)

	if active_tag:
		tween.tween_property(active_tag, "rotation", deg_to_rad(7), 0.15)

func _on_mouse_exited() -> void:	
	var tween := create_tween() \
		.set_parallel(true) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(item, "rotation", 0.0, 0.15)

	if active_tag:
		tween.tween_property(active_tag, "rotation", 0.0, 0.15)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed && event.button_index == MouseButton.MOUSE_BUTTON_LEFT :
		pressed.emit(self)
		
