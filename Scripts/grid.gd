extends Node2D

@export var width: int;
@export var height: int;
@export var x_start: int;
@export var y_start: int;
@export var offset: int;

# Possible pieces - maybe use this for orders
var possible_items = [
	preload("res://Scenes/ItemMusic.tscn")
];




var grid = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid = fill_grid_array();
	print(grid);
	#add_child(generator)
	print(find_empty_tile());

func fill_grid_array():
	var array = [];
	for i in width:
		array.append([]);
		for j in height:
			array[i].append([]);
	return array;

func grid_to_pixel(column, row):
	var new_x = x_start + offset * column;
	var new_y = y_start + -offset * row;
	return Vector2(new_x, new_y);

func find_empty_tile():
	for i in width:
		for j in height:
			if grid[i][j] == []:
				return Vector2(i, j);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
