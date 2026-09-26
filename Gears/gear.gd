extends Resource
class_name GearResource

enum Type {
	HOOK,
	SPOON,
	LINE,
	BAIT,
	
}

@export var type : Type
@export var price : int
@export var texture : Texture2D
@export_range(0, 2, 1) var level : int
## La strength est en pourcentage et soustraite a celle du poisson
@export var strenght : float
## La speed est mesurer en seconde et soustraite a celle du poisson
@export var speed : float
## La snap speed est mesurer en seconde et soustraite a celle du poisson
@export var snap : float
## La rarity est mesurer de 0 à 5 et change les poissons hooked
@export var rarity : float
