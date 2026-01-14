extends Node2D

@onready var gridFunction = $GridFunction;
@onready var deadline_container = $DeadlineScroll/DeadlineContainer;
@onready var failed_sound = $FailedSound;
@onready var completed_sound = $CompletedSound;
@onready var completed_label = $CompletedDeadline
@onready var failed_label = $FailedDeadline
@onready var ending_screen = $EndingScreen
@onready var completed_result_label = $EndingScreen/FinalResult/CompletedResult


const MAX_DEADLINES = 2;

var deadline_scene = preload("res://Scenes/Deadline.tscn")
var completed_deadlines = 0;
var failed_deadlines = 0;
	
var deadline_list = [];
var grid_removals = [];
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global.max_user_levels = {
		"music_generator": 1,
		"music_item": 1
	}
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

func on_failed_deadline(deadlines):
	deadline_list.erase(deadlines);
	failed_sound.play();
	failed_deadlines += 1;
	failed_label.text = "Failed: " + str(failed_deadlines);
	if failed_deadlines >= 3:
		end_game();

func completed_deadline():
	completed_sound.play();
	completed_deadlines += 1;
	completed_label.text = "Completed: " + str(completed_deadlines);

func end_game():
	completed_result_label.text = "Final Score: " + str(completed_deadlines);
	failed_sound.volume_db = -100;
	gridFunction.hide();
	deadline_container.hide();
	gridFunction.process_mode = Node.PROCESS_MODE_DISABLED;
	ending_screen.show();

func _on_play_again_pressed() -> void:
	get_tree().reload_current_scene();

func _on_return_to_main_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn");
