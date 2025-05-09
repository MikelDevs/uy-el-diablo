class_name Player

extends Node2D

@onready var anima = $AnimatedSprite2D
@onready var area : Area = get_parent().get_node("Area")
@onready var ui : Ui = get_parent().get_node("Ui")
@onready var combo_note_ui = preload("res://Scenes/ComboNoteUi.tscn")

@export var player_data: PlayerAttributesResource

var current_health: float
var is_attacking = false
var is_dodging = false
var is_blocking = false
var colors = {
	"Yellow": 544,
	"Blue": 512,
	"Red": 480,
	"Green": 448
}

func _ready() -> void:
	# Cargar atributos
	var 	attr = player_data.attributes
	current_health = attr.health
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
	var combo = ui.get_node("Control/HBoxContainer")
	var current_note : TextureRect = combo_note_ui.instantiate()
	
	match name_anima:
		"right_up":
			anima.play("up_attack")
			if area.get_node("AreaGrey3").is_perfect:
				ui.show_feedback("Perfect")
			elif area.get_node("AreaGrey3").is_good:
				ui.show_feedback("Good")
			else:
				ui.show_feedback("Fail")
		"right":
			anima.play("down_attack")
			if area.get_node("AreaGrey8").is_perfect:
				ui.show_feedback("Perfect")
			elif area.get_node("AreaGrey8").is_good:
				ui.show_feedback("Good")
			else:
				ui.show_feedback("Fail")
		"left_up":
			anima.flip_h = true
			anima.play("up_attack")
			if area.get_node("AreaGrey").is_perfect:
				ui.show_feedback("Perfect")
			elif area.get_node("AreaGrey").is_good:
				ui.show_feedback("Good")
			else:
				ui.show_feedback("Fail")
		"left":
			anima.flip_h = true
			anima.play("down_attack")
			if area.get_node("AreaGrey2").is_perfect:
				ui.show_feedback("Perfect")
			elif area.get_node("AreaGrey2").is_good:
				ui.show_feedback("Good")
			else:
				ui.show_feedback("Fail")
	
	combo.add_child(current_note)

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
