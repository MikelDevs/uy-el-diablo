class_name Area

extends Node2D

@onready var player_guide = $PlayerGuide
@onready var enemy_guide = $EnemyGuide

var colors = {
	"Yellow":672,
	"Blue":640,
	"Red":608,
	"Green":576
}

var attacks = [
	{"color":"Yellow", "time":0.2},
	{"color":"Yellow", "time":0.2},
	{"color":"Yellow", "time":0.2},
	{"color":"Yellow", "time":0.5},
	{"color":"Red", "time":0.5},
	{"color":"Blue", "time":0.5},
	{"color":"Red", "time":0.5},
	{"color":"Blue", "time":0.5},
	{"color":"Red", "time":0.5},
	{"color":"Blue", "time":0.5},
]

var is_attacking = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if not is_attacking and attacks.size() > 0:
		spawn_attack()

func spawn_attack():
	is_attacking = true
	var attack = preload("res://Scenes/attack.tscn").instantiate() as Attack_Node
	var sprite = attack.get_node("Sprite2D") as Sprite2D
	sprite.region_rect  =Rect2(Vector2(colors[attacks[0].color],0), Vector2(32,32))
	var point = enemy_guide.get_node(attacks[0].color)
	attack.position = Vector2(point.position.x, enemy_guide.position.y + enemy_guide.get_child(2).position.y)
	add_child(attack)
	await get_tree().create_timer(attacks[0].time).timeout
	attacks.pop_front()
	is_attacking = false
