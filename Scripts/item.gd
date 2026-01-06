extends Node2D

class_name Item

@export var item_type: String;
@export var item_level: int;
@export var item_sprite: Sprite2D;

@onready var tree_sprite = $Sprite;

var defaultImg = load("res://Assets/Icons/test_item1.png");

func _init(p_type: String = "music", p_level: int = 1, p_sprite: Sprite2D = tree_sprite):
	item_type = p_type;
	item_level = p_level;
	item_sprite = p_sprite;
	#textureImage = p_texture;
