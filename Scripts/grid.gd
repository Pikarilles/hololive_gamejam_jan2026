extends Node2D

@export var width: int;
@export var height: int;
@export var x_start: int;
@export var y_start: int;
@export var offset: int;

@onready var test_item = $ItemMusic;
@onready var merge_sound = $MergeSound;

const MAX_GENERATOR_LEVELS = {
	"music": 5
}

var generator_levels = {
	"music": 1
}

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
	var first_generator = possible_items[0].instantiate();
	first_generator.item_gen = true;
	add_child(first_generator);
	insert_item(first_generator, Vector2(0, 0));
	global.move_item.connect(on_move_item);
	generator_levels = {
		"music": 1
	}

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
			if not grid[j][i]:
				return Vector2(j, i);
	return null;
	
func get_grid():
	return grid;

func insert_item(item: Item, initial_pos: Vector2):
	
	var empty_space = find_empty_tile()

	if empty_space != null:
		grid[empty_space.x][empty_space.y] = item;
		item.position = grid_to_pixel(initial_pos.x, initial_pos.y);

		if item.item_gen == false:
			item.move(grid_to_pixel(empty_space.x, empty_space.y));
		else:
			item.position = grid_to_pixel(empty_space.x, empty_space.y);
	else:
		# If the item is a generator, backlog it for when an empty tile exists

		# Return a "board is full" message
		return null;

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var first_click = get_global_mouse_position();
			var clicked_pos = pixel_to_grid(first_click.x, first_click.y);
			var clicked_item = grid[clicked_pos.x][clicked_pos.y];
			if is_in_grid(clicked_pos.x, clicked_pos.y):
				global.update_description.emit(clicked_item);
				if event.is_double_click():
					if clicked_item.item_gen:
						if find_empty_tile() != null:
							var new_item = possible_items[0].instantiate();
							new_item.item_level = randi_range(1, generator_levels[new_item.item_type]);
							new_item.item_gen = false;
							add_child(new_item);
							insert_item(new_item, clicked_pos);

func on_move_item(first_pos, final_pos):
	var first_grid_pos = pixel_to_grid(first_pos.x, first_pos.y);
	var final_grid_pos = pixel_to_grid(final_pos.x, final_pos.y);
	var first_item = grid[first_grid_pos.x][first_grid_pos.y];
	if first_grid_pos == final_grid_pos:
		first_item.move(grid_to_pixel(first_grid_pos.x, first_grid_pos.y));
		return;
	if is_in_grid(first_grid_pos.x, first_grid_pos.y) && is_in_grid(final_grid_pos.x, final_grid_pos.y):
		process_pieces(first_grid_pos, final_grid_pos);
	else:
		first_item.move(grid_to_pixel(first_grid_pos.x, first_grid_pos.y));

func process_pieces(first_grid_pos, final_grid_pos):
	var first_item = grid[first_grid_pos.x][first_grid_pos.y];
	var other_item = grid[final_grid_pos.x][final_grid_pos.y];
	# If they are the same item, then merge it
	if first_item && other_item:
		if first_item.item_type == other_item.item_type &&\
		   first_item.item_level == other_item.item_level &&\
		   first_item.item_gen == other_item.item_gen:
			if not first_item.is_max_level():
				first_item.queue_free();
				other_item.update_level();
				grid[final_grid_pos.x][final_grid_pos.y] = other_item;
				merge_sound.play();
				if other_item.item_level > global.max_user_levels[other_item.get_type_string()]:
					global.max_user_levels[other_item.get_type_string()] += 1;
				if other_item.item_level > generator_levels[other_item.item_type] &&\
				   generator_levels[other_item.item_type] < MAX_GENERATOR_LEVELS[other_item.item_type]:
					generator_levels[other_item.item_type] += 1;
			else:
				grid[first_grid_pos.x][first_grid_pos.y] = other_item;
				grid[final_grid_pos.x][final_grid_pos.y] = first_item;
				if first_item:
					first_item.move(grid_to_pixel(final_grid_pos.x, final_grid_pos.y))
				if other_item:
					other_item.move(grid_to_pixel(first_grid_pos.x, first_grid_pos.y));
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

func remove_item(grid_position):
	var item_removed = grid[grid_position.x][grid_position.y];
	item_removed.queue_free();
