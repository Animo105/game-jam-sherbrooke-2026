extends RefCounted
class_name Rod

var pull_strenght : float = 0
var snap_resistence : float = 0
var bar_size_bonus : int = 0
var catch_speed : float = 0
var rarity : float = 0

var bait_gear : GearResource = null
var spoon_gear : GearResource = null
var line_gear : GearResource = null
var hook_gear : GearResource = null

var bait_type : FishResource.Bait = FishResource.Bait.ANY

func calculate_stats():
	pull_strenght = 0
	snap_resistence = 0
	bar_size_bonus = 0
	catch_speed = 0
	rarity = 0
	bait_type = FishResource.Bait.ANY
	if bait_gear:
		_append_gear(bait_gear)
		if bait_gear.level == 0:
			bait_type = FishResource.Bait.WORM
		if bait_gear.level == 1:
			bait_type = FishResource.Bait.SHRIMP
		elif bait_gear.level == 2:
			bait_type = FishResource.Bait.OCTOPUS
	if spoon_gear:
		_append_gear(spoon_gear)
	if line_gear:
		_append_gear(line_gear)
	if hook_gear:
		_append_gear(hook_gear)

func _append_gear(gear : GearResource):
	pull_strenght += gear.strenght
	snap_resistence += gear.snap
	catch_speed += gear.speed
	rarity += gear.rarity
