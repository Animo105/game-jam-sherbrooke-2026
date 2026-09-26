extends Control

const REEL_FRAMES_COOLDOWN : int = 3
const FISH_CHANGE_DIRECTION_ATTEMPT_COOLDOWN : int = 5

@onready var fishing_bar: FishingBar = $MarginContainer/FishingBar/FishingBar
@onready var timer: Timer = $Timer
@onready var fish_sprite: Sprite2D = $FishSprite

var reel_cooldown : int = 0
var current_fish : FishResource = null
var catch_timer : float = 0
var fish_speed : float = 0
var fish_direction : float = 0
var frame_countdown = FISH_CHANGE_DIRECTION_ATTEMPT_COOLDOWN
var is_inside_zone : bool = false
var tween : Tween

func _ready() -> void:
	await fishing_bar.resized # thrust ca marche pas sans ca
	new_fish(FishManager.fish_list["fish"])

func new_fish(fish : FishResource):
	current_fish = fish
	fish_sprite.texture = fish.texture
	catch_timer = fish.catch_difficulty - Globals.rod.catch_speed
	fish_speed = fish.speed - Globals.rod.pull_strenght
	fish_direction = 1 if randf() < 0.5 else -1
	fish_sprite.flip_h = fish_direction < 0
	fish_sprite.global_position = Vector2(randf_range(fishing_bar.leftmost_x_position, fishing_bar.rightmost_x_position), fishing_bar.absolute_center_position.y)

func _physics_process(delta: float) -> void:
	fish_physic_frame(delta)
	
func fish_physic_frame(delta : float) -> void:
	if not current_fish: return # pas de fish a reel
	var new_x = fish_sprite.global_position.x + (fishing_bar.get_amount_px_for_speed(fish_speed) * fish_direction * delta)
	frame_countdown -= 1
	if frame_countdown <= 0:
		if randf() < current_fish.direction_change_frequency:
			fish_direction *= -1
			fish_sprite.flip_h = fish_direction < 0
		frame_countdown = FISH_CHANGE_DIRECTION_ATTEMPT_COOLDOWN
	# do reeling
	if Input.is_action_just_pressed("left"):
		new_x -= fishing_bar.pull_amount_px
	if Input.is_action_just_pressed("right"):
		new_x += fishing_bar.pull_amount_px
	# move fish
	fish_sprite.global_position.x = clamp(new_x, fishing_bar.leftmost_x_position, fishing_bar.rightmost_x_position)
	# do catch or break cycle
	# ##### a changer ##### #
	var new_is_inside_zone :bool = fishing_bar.is_inside_zone(fish_sprite.global_position.x)
	if new_is_inside_zone != is_inside_zone:
		is_inside_zone = new_is_inside_zone
		shaking_fish_or_bar()
	# ###################### #
	if is_inside_zone:
		pass
		# catch time decrease,
		# recover line damage
	else:
		pass
		# damage line

func shaking_fish_or_bar():
		if tween:
			tween.kill()
		tween = create_tween()
		tween.set_loops()
		fish_sprite.scale = Vector2(0.5,0.5)
		fishing_bar.offset_left = 0
		if is_inside_zone:
			tween.tween_property(fish_sprite, "scale", Vector2(0.45,0.45), 0.1)
			tween.tween_property(fish_sprite,"scale", Vector2(0.5,0.5), 0.1)
		else:
			tween.tween_property(fishing_bar,"offset_transform_position", Vector2(0,2), 0.1)
			tween.tween_property(fishing_bar,"offset_transform_position", Vector2(0,-2), 0.1)

func update_day_timer():
	var progress : float = 1 - (timer.time_left/Globals.DAY_DURATION)
