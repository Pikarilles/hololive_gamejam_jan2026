extends Control

#signal completed_order
signal check_deadline(deadline)
signal failed_deadline(deadline)

@onready var deadline_list_box = $DeadlineList;
@onready var timer_bar = $VBoxContainer/TimeRemaining;
@onready var timer = $VBoxContainer/TimeRemaining/Timer;
@onready var success_sound = $SuccessSound;
@onready var fail_sound = $FailSound;
@onready var click_area = $ClickArea

const MARGINS = 30;
const SPACING = 55;

var item_scene = preload("res://Scenes/ItemMusic.tscn");

var deadlines = [];

var MAX_LEVELS = {
	"music_generator": 1,
	"music_item": 8
}

func _ready() -> void:
	generate_deadline();
	
# Function to generate an order
func generate_deadline():
	var item_amount = randi_range(1, 3);
	
	for i in item_amount:
		var item = item_scene.instantiate();
		var user_max = global.max_user_levels[item.get_type_string()];
		if user_max < MAX_LEVELS[item.get_type_string()]:
			user_max += 1;
		
		item.item_click = false;
		item.item_level = randi_range(1, user_max);
		#add_child(item);
		deadlines.append(item);
		#var item_rect = TextureRect.new();
		#item_rect.texture = item.texture;
		#item_rect.texture = load("res://Assets/Icons/music_item1.png");
		#item_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE;
		#item_rect.custom_minimum_size = Vector2(55, 55);
		#item_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		deadline_list_box.add_child(item);
		item.position = Vector2(MARGINS + i * SPACING, MARGINS);

func _physics_process(_delta: float):
	timer_bar.value = timer.wait_time - timer.time_left;

func _on_timer_timeout() -> void:
	# Delete itself and send +1 to failed orders
	failed_deadline.emit(self);
	queue_free(); # Replace with function body.

# Function to check if an order is complete
func complete_deadline():
	queue_free();

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			check_deadline.emit(self);

func get_deadline_list():
	return deadlines;
