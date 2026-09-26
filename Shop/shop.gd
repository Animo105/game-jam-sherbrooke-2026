extends Control

var buying_slots : Array[TextureButton] = []

func _ready() -> void:
	buying_slots.assign(get_tree().get_nodes_in_group("buying_slots"))
	
	for slot in buying_slots:
		slot.pivot_offset = slot.size / 2
		slot.pressed.connect(_on_slot_pressed.bind(slot))
		slot.mouse_entered.connect(_on_slot_hover.bind(slot, true))
		slot.mouse_exited.connect(_on_slot_hover.bind(slot, false))

func _process(delta: float) -> void:
	pass

func _on_slot_hover(slot: TextureButton, is_hovered: bool) -> void:
	var target_scale = Vector2(1.1, 1.1) if is_hovered else Vector2(1.0, 1.0)
	var tween = create_tween()
	tween.tween_property(slot, "scale", target_scale, 0.15).set_trans(Tween.TRANS_SINE)

func _on_slot_pressed(slot: TextureButton) -> void:
	var tween = create_tween()
	tween.tween_property(slot, "scale", Vector2(0.0, 0.0), 0.15).set_trans(Tween.TRANS_SINE)
