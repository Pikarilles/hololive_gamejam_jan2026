extends Node2D

@export var width: int;
@export var height: int;
@export var x_start: int;
@export var y_start: int;
@export var offset: int;

@onready var test_item = $ItemMusic;

# Placeholder generator variable


# Possible pieces - maybe use this for the deadlines
var possible_items = [
	preload("res://Scenes/ItemMusic.tscn")
];

var possible_generators = [
	preload("res://Scenes/ItemMusic.tscn")
];

var grid = [];

func _ready() -> void:
	grid = fill_grid_array();
	var first_generator = possible_items[0].instantiate();
	add_child(first_generator);
	insert_item(first_generator);

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
	return null;

func insert_item(item: Item):
	# Find an empty tile
	var empty_space = find_empty_tile()
	# Add item to the empty tile
	if empty_space != null:
		print(empty_space);
		grid[empty_space.x][empty_space.y] = item;
		item.position = grid_to_pixel(empty_space.x, empty_space.y);
		print (item.position);
	else:
		# If the item is a generator, backlog it for when an empty tile exists

		# Return a "board is full message"
		return null;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
