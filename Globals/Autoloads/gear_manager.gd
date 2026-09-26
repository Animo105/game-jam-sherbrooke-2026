extends Node

const FISH_FOLDER_PATH = "res://Gears/Resources/"

var bait_list : Array[GearResource]
var spoon_list : Array[GearResource]
var hook_list : Array[GearResource]
var line_list : Array[GearResource]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for file in DirAccess.get_files_at(FISH_FOLDER_PATH):
		if ResourceLoader.exists(FISH_FOLDER_PATH + file):
			var res = ResourceLoader.load(FISH_FOLDER_PATH + file)
			if res is GearResource:
				if res.type == GearResource.Type.BAIT:
					bait_list.append(res)
				elif res.type == GearResource.Type.SPOON:
					spoon_list.append(res)
				elif res.type == GearResource.Type.HOOK:
					hook_list.append(res)
				elif res.type == GearResource.Type.LINE:
					line_list.append(res)
