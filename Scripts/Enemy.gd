class_name Enemy
extends Node2D

@export var enemy_data: EnemyAttributesResource
@onready var anima : AnimatedSprite2D = $AnimatedSprite2D

var current_health: float

func _ready():
	
	# Cargar sprite
	#var sprite = $Sprite2D
	#sprite.texture = enemy_data.sprite_sheet
	#sprite.region_enabled = enemy_data.is_rect
	#sprite.region_rect = enemy_data.sprite_region
	anima.flip_h = true
	anima.play()

	# Cargar atributos
	var attr = enemy_data.attributes
	current_health = attr.health
