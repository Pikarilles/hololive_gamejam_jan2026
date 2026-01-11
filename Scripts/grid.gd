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

var first_touch = Vector2(0, 0);
var final_touch = Vector2(0, 0);
var controlling = false;
var test;

func _ready() -> void:
	grid = fill_grid_array();
	for i in width:
		for j in (height/2):
			var first_generator = possible_items[0].instantiate();
			add_child(first_generator);
			insert_item(first_generator);
			global.move_item.connect(on_move_item);

func fill_grid_array():
	var array = [];
	for i in width:
		array.append([]);
		for j in height:
			array[i].append([]);
	return array;

func grid_to_pixel(column, row):
	var new_x = x_start + (offset * column);
	var new_y = y_start + (offset * row);
	return Vector2(new_x, new_y);

func pixel_to_grid(pixel_x, pixel_y):
	var new_x = round((pixel_x - x_start) / offset);
	var new_y = round((pixel_y - y_start) / offset);
	return Vector2(new_x, new_y);
	
func is_in_grid(column, row):
	if column >= 0 && column < width:
		if row >= 0 && row < height:
			return true;
	return false;

func find_empty_tile():
	for i in width:
		for j in height:
			if not grid[i][j]:
				return Vector2(i, j);
	return null;

func insert_item(item: Item):
	# Find an empty tile
	var empty_space = find_empty_tile()
	# Add item to the empty tile
	if empty_space != null:
		grid[empty_space.x][empty_space.y] = item;
		item.position = grid_to_pixel(empty_space.x, empty_space.y);
	else:
		# If the item is a generator, backlog it for when an empty tile exists

		# Return a "board is full" message
		return null;
		
# TODO: Create function for generating items if the item is a generator
# This would involve detecting clicks/double-clicks
# Click - select icon and show desc
# Double-click - generate new item
#func touch_input():
	#if Input.is_action_just_pressed("ui_touch"):
		#first_touch = get_global_mouse_position();
		#var grid_position = pixel_to_grid(first_touch.x, first_touch.y);
		#if is_in_grid(grid_position.x, grid_position.y):
			#controlling = true;
		#print(grid_position);
	#if Input.is_action_just_released("ui_touch"):
		#final_touch = get_global_mouse_position();
		#var grid_position = pixel_to_grid(final_touch.x, final_touch.y);
		#if is_in_grid(grid_position.x, grid_position.y) && controlling:
			#touch_difference(pixel_to_grid(first_touch.x, first_touch.y), grid_position);
			#controlling = false;

func on_move_item(first_pos, final_pos):
	var first_grid_pos = pixel_to_grid(first_pos.x, first_pos.y);
	var final_grid_pos = pixel_to_grid(final_pos.x, final_pos.y);
	var first_item = grid[first_grid_pos.x][first_grid_pos.y];
	if is_in_grid(first_grid_pos.x, first_grid_pos.y) && is_in_grid(final_grid_pos.x, final_grid_pos.y):
		process_pieces(first_grid_pos, final_grid_pos);
	else:
		first_item.move(grid_to_pixel(first_grid_pos.x, first_grid_pos.y));

func process_pieces(first_grid_pos, final_grid_pos):
	var first_item = grid[first_grid_pos.x][first_grid_pos.y];
	var other_item = grid[final_grid_pos.x][final_grid_pos.y];
	# If they are the same item, then merge it
	if first_item && other_item:
		if first_item.item_type == other_item.item_type && first_item.item_level == other_item.item_level:
			first_item.queue_free();
			other_item.update_level();
			grid[final_grid_pos.x][final_grid_pos.y] = other_item;
		else:
			grid[first_grid_pos.x][first_grid_pos.y] = other_item;
			grid[final_grid_pos.x][final_grid_pos.y] = first_item;
			if first_item:
				first_item.move(grid_to_pixel(final_grid_pos.x, final_grid_pos.y))
			if other_item:
				other_item.move(grid_to_pixel(first_grid_pos.x, first_grid_pos.y));
	else:
	# Else, swap tiles
		grid[first_grid_pos.x][first_grid_pos.y] = other_item;
		grid[final_grid_pos.x][final_grid_pos.y] = first_item;
		if first_item:
			first_item.move(grid_to_pixel(final_grid_pos.x, final_grid_pos.y))
		if other_item:
			other_item.move(grid_to_pixel(first_grid_pos.x, first_grid_pos.y));

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#	touch_input();
	pass;
