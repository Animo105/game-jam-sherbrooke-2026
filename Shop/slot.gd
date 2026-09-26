class_name Slot
extends Control

@onready var item: TextureRect = $Item

@onready var tag: TextureRect = $Tag
@onready var price: Label = $Tag/Price

@onready var tag_big: TextureRect = $TagBig
@onready var price_big: Label = $TagBig/Price

@onready var tag_small: TextureRect = $TagSmall
@onready var price_small: Label = $TagSmall/Price

var active_tag: TextureRect

func setup(gear: Gear) -> void:
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
	active_tag.get_child(0).text = "%d$" % gear.price

func _process(delta: float) -> void:
	item.position.y = sin(Time.get_ticks_msec() * 0.0015) * 5.0


func _on_mouse_entered() -> void:
	var tween := create_tween() \
		.set_parallel(true) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(item, "rotation", deg_to_rad(10), 0.15)

	if active_tag:
		tween.tween_property(active_tag, "rotation", deg_to_rad(10), 0.15)


func _on_mouse_exited() -> void:
	var tween := create_tween() \
		.set_parallel(true) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_OUT)

	tween.tween_property(item, "rotation", 0.0, 0.15)

	if active_tag:
		tween.tween_property(active_tag, "rotation", 0.0, 0.15)
