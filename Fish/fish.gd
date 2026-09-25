extends Resource
class_name FishResource

enum Depth {
	SHALLOW,
	DEEP,
}

enum Bait {
	WORM,
	CORN,
}

## Temps de catch
@export var catch_difficulty : float
## Vitesse de fuite du poisson
@export var speed : int
## 
@export var speed_boost : int
@export var speed_boost_frequency : float
@export var direction_change_frequency : float

@export var base_value : float

@export var bait_type : Bait
@export var depth : Depth
