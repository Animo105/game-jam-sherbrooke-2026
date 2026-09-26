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
