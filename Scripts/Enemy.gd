class_name Enemy
extends Node2D

@export var enemy_data: EnemyAttributesResource
@onready var anima : AnimatedSprite2D = $AnimatedSprite2D
@onready var attr = enemy_data.attributes

var current_health: float
var current_stock: int
var current_speed: float

func _ready():
	
	# Cargar sprite
	#var sprite = $Sprite2D
	#sprite.texture = enemy_data.sprite_sheet
	#sprite.region_enabled = enemy_data.is_rect
	#sprite.region_rect = enemy_data.sprite_region
	anima.flip_h = true
	anima.play()

	# Cargar atributos
	current_health = attr.health
	current_stock = attr.stock
	current_speed = attr.speed

func restock():
	current_stock = attr.stock

func change_hp(value:float, is_pluse:bool):
	if is_pluse:
		current_health += value
	else:
		current_health -= value
