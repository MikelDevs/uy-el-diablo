# EnemyAttributesResource.gd
extends Resource
class_name EnemyAttributesResource

@export var display_name: String
@export var sprite_sheet: Texture2D
@export var is_rect: bool
@export var sprite_region: Rect2

@export var attributes: CharacterAttributes
