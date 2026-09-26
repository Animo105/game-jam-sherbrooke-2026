extends Control

const FISH_CHANGE_DIRECTION_ATTEMPT_COOLDOWN : int = 5
const MINIMAL_SNAP_STRENGHT_s : float = 3
const BAIT_RATE_RANGE : Vector2 = Vector2(1, 2)

@onready var fishing_bar: FishingBar = %FishingBar
@onready var catch_progress_bar: CatchProgressBar = %CatchProgressBar
@onready var timer: Timer = $Timer
@onready var fish_sprite: Sprite2D = %FishSprite
@onready var fish_group: Node2D = %FishGroup

@onready var money_label: Label = %money_label
var total_money_today : int = 0
var displayed_money : int = 0 :
	set(value):
		displayed_money = value
		if money_label:
			money_label.text = str(value)

var money_tween : Tween

var bait_timer_s : float = 0

var current_fish : FishResource = null
var max_catch_timer : float = 0
var catch_timer_s : float = 0
var catch_recovery_s : float = 0
var fish_speed : float = 0
var fish_direction : float = 0
var frame_countdown = FISH_CHANGE_DIRECTION_ATTEMPT_COOLDOWN
var is_inside_zone : bool = false
var tween : Tween

func _ready() -> void:
	bait_timer_s = randf_range(BAIT_RATE_RANGE.x, BAIT_RATE_RANGE.y)

func new_fish(fish : FishResource):
	if current_fish: return # déja un fish
	current_fish = fish
	fish_sprite.texture = fish.texture if fish.seen else fish.hidden_texture
	fish_sprite.visible = true
	max_catch_timer = fish.catch_difficulty - Globals.rod.catch_speed
	catch_timer_s = max_catch_timer
	catch_recovery_s = clamp(current_fish.catch_recovery_speed - Globals.rod.snap_resistence, 0, Globals.MAX_SNAP_SPEED)
	fish_speed = fish.speed - Globals.rod.pull_strenght
	fish_direction = 1 if randf() < 0.5 else -1
	fish_sprite.flip_h = fish_direction < 0
	fish_sprite.global_position = fishing_bar.absolute_center_position

func _physics_process(delta: float) -> void:
	fish_physic_frame(delta)
	try_catch_fish(delta)

func try_catch_fish(delta : float):
	if current_fish: return # si ya un fish faut pas
	if bait_timer_s <= 0:
		bait_timer_s = randf_range(BAIT_RATE_RANGE.x, BAIT_RATE_RANGE.y)
		new_fish(FishManager.pick_a_fish())
	bait_timer_s -= delta

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
		if catch_timer_s <= 0:
			catch()
	else:
		pass
		catch_timer_s = clamp(catch_timer_s + delta, 0, max_catch_timer)
		if catch_timer_s == max_catch_timer:
			snap()
	# update catch bar
	catch_progress_bar.set_value(1-(catch_timer_s/max_catch_timer))

func catch():
	var bucket_preview : FishRigidBody = FishRigidBody.new(current_fish.texture)
	bucket_preview.position.x = randf_range(-100, 100)
	fish_group.add_child(bucket_preview)
	SplashAudioSound.play_splash()
	total_money_today += int(current_fish.base_value)
	if money_tween:
		money_tween.kill()
	money_tween = create_tween()
	money_tween.tween_property(self, "displayed_money", total_money_today, 0.5)
	fish_sprite.texture = null
	fish_sprite.visible = false
	current_fish.seen = true
	current_fish = null

func snap():
	print("Ho oh...!")
	fish_sprite.texture = null
	fish_sprite.visible = false
	current_fish = null

func shaking_fish_or_bar():
		if tween:
			tween.kill()
		fish_sprite.scale = Vector2(0.5,0.5)
		fishing_bar.offset_transform_rotation = 0
		if is_inside_zone:
			tween = create_tween()
			tween.set_loops()
			tween.tween_property(fish_sprite, "scale", Vector2(0.48,0.48), 0.05)
			tween.tween_property(fish_sprite,"scale", Vector2(0.5,0.5), 0.05)
		else:
			tween = create_tween()
			tween.set_loops()
			tween.tween_property(fishing_bar,"offset_transform_rotation", 0.01, 0.1)
			tween.tween_property(fishing_bar,"offset_transform_rotation", -0.01, 0.1)

func update_day_timer():
	var progress : float = 1 - (timer.time_left/Globals.DAY_DURATION)


func _on_timer_timeout() -> void:
	pass # Replace with function body.
