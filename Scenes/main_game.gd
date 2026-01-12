extends Node2D

@onready var grid = $GridFunction;
@onready var deadline_container = $DeadlineScroll/DeadlineContainer;
@onready var failed_sound = $FailedSound;

const MAX_DEADLINES = 2;

var deadline_scene = preload("res://Scenes/Deadline.tscn")
var completed_orders = 0;
var failed_orders = 0;

var deadline_list = [];
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_deadline_list(); # Replace with function body.

func generate_deadline_list():
	while deadline_list.size() < MAX_DEADLINES:
		print(deadline_list.size());
		var deadline = deadline_scene.instantiate();
		deadline_list.append(deadline);
		deadline_container.add_child(deadline);
		deadline.failed_order.connect(on_failed_order);
		deadline.completed_order.connect(on_failed_order);
		pass;
	print(deadline_list);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	#for i in deadline_list:
		#deadline_list[i].failed_order.connect(on_failed_order);
	pass
	
func on_failed_order():
	failed_sound.play();
	failed_orders += 1;
	#print(failed_orders);
