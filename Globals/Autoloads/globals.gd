extends Node

const DAY_DURATION : float = 300
const PULL_FORCE_PERCENT : float = 0.05
const MAX_SNAP_SPEED : float = 10
const MIN_SNAP_SPEED : float = 0.5

var money : float
var level_unlocked : Dictionary[int, bool]

func _ready() -> void:
	level_unlocked[0] = true
	rod.snap_resistence = 1

var rod : Rod = Rod.new()
var current_habitat : int = 0
