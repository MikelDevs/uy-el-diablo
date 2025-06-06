class_name Player

extends Node2D

@onready var anima = $AnimatedSprite2D
@onready var attr = player_data.attributes
@export var player_data: PlayerAttributesResource

signal onAttack(attack:String)

var current_health: float
var current_stock: int
var current_speed: float
var is_attacking = false
var is_dodging = false
var is_blocking = false

func _ready() -> void:
	current_health = attr.health
	current_stock = attr.stock
	current_speed = attr.speed
	
	anima.play("idle")

func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_attack") and not is_attacking:
		attack(select_target())
	if Input.is_action_just_released("ui_attack"):
		is_attacking = false
		anima.flip_h = false
		anima.play("idle")
	if Input.is_action_pressed("ui_block") and not is_blocking:
		block(select_target())
	if Input.is_action_just_released("ui_block"):
		is_blocking = false
		anima.flip_h = false
		anima.play("idle")
	if Input.is_action_pressed("ui_dodge") and not is_dodging:
		dodge(select_target())
	if Input.is_action_just_released("ui_dodge"):
		is_dodging = false
		anima.flip_h = false
		anima.play("idle")

func select_target() -> String:
	if Input.is_action_pressed("ui_right"):
		return "right"
	elif Input.is_action_pressed("ui_left"):
		return "left"
	elif Input.is_action_pressed("ui_down"):
		return "down"
	elif Input.is_action_pressed("ui_right_up"):
		return "right_up"
	elif Input.is_action_pressed("ui_left_up"):
		return "left_up"
	return "none"

func attack(name_anima:String) -> void:
	if name_anima == "none":
		return
	
	is_attacking = true
	
	match name_anima:
		"right_up":
			anima.play("e_attack")
			emit_signal("onAttack", "e")
		"right":
			anima.play("f_attack")
			emit_signal("onAttack", "f")
		"left_up":
			anima.play("w_attack")
			emit_signal("onAttack", "w")
		"left":
			anima.play("a_attack")
			emit_signal("onAttack", "a")

func block(name_anima:String) -> void:
	if name_anima == "none":
		return
	
	is_blocking = true
	
	match name_anima:
		"right_up":
			anima.play("up_block")
		"right":
			anima.play("down_block")
		"left_up":
			anima.flip_h = true
			anima.play("up_block")
		"left":
			anima.flip_h = true
			anima.play("down_block")

func dodge(name_dodge:String) -> void:
	if name_dodge == "none":
		return
		
	is_dodging = true
	
	match name_dodge:
		"right":
			anima.play("side_dodge")
		"down":
			anima.play("dodge_down")
		"left":
			anima.flip_h = true
			anima.play("side_dodge")

func restock():
	current_stock = attr.stock

func change_hp(value:float, is_pluse:bool):
	if is_pluse:
		current_health += value
	else:
		current_health -= value
