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


func reeling_process():
	if Input.is_action_just_pressed("left"):
		pass
	if Input.is_action_just_pressed("right"):
		pass

func fish_physic_frame(delta : float) -> void:
	if not current_fish: return # pas de fish a reel
	var new_x = fish_sprite.global_position.x + (fishing_bar.get_amount_px_for_speed(fish_speed) * fish_direction * delta)
	fish_sprite.global_position.x = clamp(new_x, fishing_bar.leftmost_x_position, fishing_bar.rightmost_x_position)
	frame_countdown -= 1
	if frame_countdown <= 0:
		if randf() < current_fish.direction_change_frequency:
			fish_direction *= -1
			fish_sprite.flip_h = fish_direction < 0
		frame_countdown = FISH_CHANGE_DIRECTION_ATTEMPT_COOLDOWN

func update_day_timer():
	var progress : float = 1 - (timer.time_left/Globals.DAY_DURATION)
