extends Control

const FISH_CHANGE_DIRECTION_ATTEMPT_COOLDOWN : int = 5
const MINIMAL_SNAP_STRENGHT_s : float = 3

@onready var fishing_bar: FishingBar = %FishingBar
@onready var catch_progress_bar: CatchProgressBar = %CatchProgressBar
@onready var timer: Timer = $Timer
@onready var fish_sprite: Sprite2D = %FishSprite

var current_fish : FishResource = null
var max_catch_timer : float = 0
var max_snap_timer : float = 0
var catch_timer_s : float = 0
var catch_recovery_s : float = 0
var snap_timer_s : float = 0
var snap_recovery_s : float = 0
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
	max_catch_timer = fish.catch_difficulty - Globals.rod.catch_speed
	catch_timer_s = max_catch_timer
	catch_recovery_s = current_fish.catch_recovery_speed
	max_snap_timer = Globals.rod.snap_speed - current_fish.snap_strenght
	snap_timer_s = max_snap_timer
	snap_recovery_s = Globals.rod.snap_recovery_speed
	fish_speed = fish.speed - Globals.rod.pull_strenght
	fish_direction = 1 if randf() < 0.5 else -1
	fish_sprite.flip_h = fish_direction < 0
	fish_sprite.global_position = fishing_bar.absolute_center_position

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
	#fish_sprite.global_position.y = fishing_bar.absolute_center_position.y
	# do catch or break cycle
	# ##### a changer ##### #
	var new_is_inside_zone :bool = fishing_bar.is_inside_zone(fish_sprite.global_position.x)
	if new_is_inside_zone != is_inside_zone:
		is_inside_zone = new_is_inside_zone
		shaking_fish_or_bar()
	# ###################### #
	if is_inside_zone:
		pass
		catch_timer_s -= delta
		snap_timer_s = clamp(snap_timer_s + delta, 0, max_snap_timer)
		if catch_timer_s <= 0:
			pass # catch
	else:
		pass
		snap_timer_s -= delta
		catch_timer_s = clamp(catch_timer_s + delta, 0, max_catch_timer)
		if snap_timer_s <= 0:
			pass # snapp
	# update catch bar
	catch_progress_bar.set_value(1-(catch_timer_s/max_catch_timer))

func shaking_fish_or_bar():
		if tween:
			tween.kill()
		fish_sprite.scale = Vector2(0.5,0.5)
		fishing_bar.offset_left = 0
		if is_inside_zone:
			tween = create_tween()
			tween.set_loops()
			tween.tween_property(fish_sprite, "scale", Vector2(0.48,0.48), 0.05)
			tween.tween_property(fish_sprite,"scale", Vector2(0.5,0.5), 0.05)
		else:
			tween = create_tween()
			tween.set_loops()
			tween.tween_property(fishing_bar,"offset_transform_position", Vector2(0,1.5), 0.1)
			tween.tween_property(fishing_bar,"offset_transform_position", Vector2(0,-1.5), 0.1)

func update_day_timer():
	var progress : float = 1 - (timer.time_left/Globals.DAY_DURATION)
