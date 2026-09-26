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
## Sprite du fish
@export var texture : Texture2D
## Temps de catch (seconde)
@export var catch_difficulty : float
## Vitesse de fuite du poisson (% seconde (1=100%))
@export var speed : float
### Fréquence de changement de direction (chance every 5 frames)
@export var direction_change_frequency : float
### base sell_value
@export var base_value : float

##don't ask me
@export var bait_type : Bait
##don't ask me
@export var depth : Depth
##IDK
@export var habitat : int
