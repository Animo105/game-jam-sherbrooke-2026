extends Node

const FISH_FOLDER_PATH = "res://Fish/Resources/"

var fish_list : Dictionary[String,FishResource]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for file in DirAccess.get_files_at(FISH_FOLDER_PATH):
		if ResourceLoader.exists(FISH_FOLDER_PATH + file):
			var fish_name : String = file.trim_suffix(".tres")
			var res = ResourceLoader.load(FISH_FOLDER_PATH + file)
			if res is FishResource:
				fish_list[fish_name] = res

func pick_a_fish() -> FishResource:
	var can_pick : Array[FishResource] = []
	var current_bait_type : FishResource.Bait = Globals.rod.bait_type
	for fish : FishResource in fish_list.values():
		if fish.habitat != Globals.current_habitat:
			continue
		if fish.bait_type == FishResource.Bait.ANY or fish.bait_type == current_bait_type:
			can_pick.append(fish)
		
	var rng = RandomNumberGenerator.new()
	var weights : Array = []
	for x : FishResource in can_pick:
		if x.rarity > Globals.rod.rarity:
			weights.append(0.5)
		else :
			weights.append(2.0)
	return can_pick[rng.rand_weighted(weights)]
