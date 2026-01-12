extends Node2D

@onready var gridFunction = $GridFunction;
@onready var deadline_container = $DeadlineScroll/DeadlineContainer;
@onready var failed_sound = $FailedSound;
@onready var completed_sound = $CompletedSound;

const MAX_DEADLINES = 2;

var deadline_scene = preload("res://Scenes/Deadline.tscn")
var completed_orders = 0;
var failed_orders = 0;

var deadline_list = [];
var grid_removals = [];
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_deadline_list(); # Replace with function body.

func generate_deadline_list():
	while deadline_list.size() < MAX_DEADLINES:
		var deadline = deadline_scene.instantiate();
		deadline_list.append(deadline);
		deadline_container.add_child(deadline);
		deadline.failed_deadline.connect(on_failed_deadline);
		deadline.check_deadline.connect(on_check_deadline);

func _process(_delta: float):
	if deadline_list.size() < MAX_DEADLINES:
		generate_deadline_list();
	
func on_check_deadline(deadlines):
	var grid = gridFunction.get_grid();
	var deadline_array = deadlines.get_deadline_list();
	var temp_deadlines = deadline_array;
	grid_removals = [];
	while temp_deadlines.size() >= 0:
		for i in grid.size():
			for j in grid[i].size():
				if grid[j][i]:
					for k in deadline_array.size():
						#print("Checking vector " +str(j) + " " + str(i));
						if grid[j][i].item_type == temp_deadlines[k].item_type &&\
						   grid[j][i].item_level == temp_deadlines[k].item_level &&\
						   grid[j][i].item_gen == temp_deadlines[k].item_gen:
								temp_deadlines.remove_at(k);
								grid_removals.append(Vector2(j, i));
								break;
		if not temp_deadlines.is_empty():
			return false;
		else:
			deadline_list.erase(deadlines);
			completed_deadline()
			deadlines.complete_deadline();
			update_grid(grid_removals);
			return true;
	deadline_list.erase(deadlines);
	completed_deadline()
	deadlines.complete_deadline();
	update_grid(grid_removals);
	return true;

func update_grid(grid_removal_list):
	for i in grid_removal_list.size():
		gridFunction.remove_item(grid_removal_list[i]);

func on_failed_deadline():
	failed_sound.play();
	failed_orders += 1;

func completed_deadline():
	completed_sound.play();
	completed_orders += 1;
