extends Node2D

@onready var flame_golem : Enemy = preload("res://Scenes/Enemy.tscn").instantiate()
@onready var player : Player = preload("res://Scenes/Player.tscn").instantiate()
@onready var ui : Ui = $Ui
@onready var area : Area = $Area

const _default_player_position : Vector2 = Vector2(960, 900)
const _default_enemy_position : Vector2 = Vector2(960, 100)

func _ready() -> void:
	flame_golem.enemy_data = preload("res://Attributes/Enemies/FlameGolem.tres")
	player.player_data = preload("res://Attributes/Player/Player.tres")
	
	set_characters()
	
	start_combat()

func start_combat() -> void:
	var numbers = ["3", "2", "1", "START!"]
	var label_start = ui.get_node("Control/text")
	label_start.visible = true
	for text in numbers:
		label_start.text = text
		await get_tree().create_timer(1.0).timeout 
	label_start.visible = false  
	area.start_combat()

func set_characters() -> void:
	flame_golem.position = _default_enemy_position
	player.position = _default_player_position
	add_child(player)
	add_child(flame_golem)
	move_child(flame_golem, 0)
	move_child(player, 0)
