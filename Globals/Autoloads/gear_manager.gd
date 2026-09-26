extends Node

const FISH_FOLDER_PATH = "res://Gears/Resources/"

var gear_list : Array[GearResource]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for file in DirAccess.get_files_at(FISH_FOLDER_PATH):
		if ResourceLoader.exists(FISH_FOLDER_PATH + file):
			var res = ResourceLoader.load(FISH_FOLDER_PATH + file)
			if res is GearResource:
				gear_list.append(res)
