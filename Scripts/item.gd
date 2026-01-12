extends Sprite2D

class_name Item

@export var item_type: String;
@export var item_level: int;
@export var item_gen: bool;
@export var item_click: bool;

var MAX_LEVELS = {
	"music_generator": 1,
	"music_item": 6
}

var first_position = Vector2(0, 0);
var final_position = Vector2(0, 0);

var is_dragging = false;
var mouse_offset;
var delay = 2;

func _physics_process(delta: float):
	if is_dragging == true:
		var tween = get_tree().create_tween();
		tween.tween_property(self, "position", get_global_mouse_position() - mouse_offset, delay * delta);

func _input(event):
	if item_click:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if get_rect().has_point(to_local(event.position)):
					first_position = event.position;
					is_dragging = true;
					mouse_offset = get_global_mouse_position() - global_position;
			else:
				if get_rect().has_point(to_local(event.position)) && is_dragging:
					final_position = event.position;
					is_dragging = false;
					global.move_item.emit(first_position, final_position);

func _init(p_type: String = "music", p_level: int = 1,
		   p_gen: bool = false, p_click: bool = true):
	item_type = p_type;
	item_level = p_level;
	item_gen = p_gen;
	item_click = p_click;

func _ready():
	image_manager(item_level);

func move(target):
	var move_tween = create_tween();
	move_tween.set_trans(Tween.TRANS_LINEAR);
	move_tween.set_ease(Tween.EASE_OUT);
	move_tween.tween_property(self, "position", target, 0.1);
	move_tween.play();

func update_level():
	item_level = item_level + 1;
	image_manager(item_level);
	
func image_manager(level):
	var file_string = "";
	var text_gen = "";
	
	if item_gen:
		text_gen = "generator";
	else:
		text_gen = "item";
		
	file_string = item_type + "_" + text_gen + str(level);
	var texture_image = load("res://Assets/Icons/" + file_string + ".png");
	self.texture = texture_image;

func is_max_level():
	var dict_string = "";
	var text_gen = "";
	
	if item_gen:
		text_gen = "generator";
	else:
		text_gen = "item";
		
	dict_string = item_type + "_" + text_gen;
	
	if dict_string in MAX_LEVELS:
		if MAX_LEVELS[dict_string] == item_level:
			return true;
		else:
			return false;
	return false;
	
