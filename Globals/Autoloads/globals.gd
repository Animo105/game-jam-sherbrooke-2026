extends Node

const DAY_DURATION : float = 300
const PULL_FORCE_PERCENT : float = 0.05

var money : float
var level_unlocked : Dictionary[int, bool]

func _ready() -> void:
	level_unlocked[0] = true

var rod : Rod = Rod.new()
