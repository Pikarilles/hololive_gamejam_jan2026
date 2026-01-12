extends Control

@onready var order_list_box = $OrderList;
@onready var timer_bar = $VBoxContainer/TimeRemaining;
@onready var timer = $VBoxContainer/TimeRemaining/Timer;

var item_scene = preload("res://Scenes/ItemMusic.tscn");

var order = [];

func _ready() -> void:
	generate_order();
	pass # Replace with function body.

# Function to generate an order
func generate_order():
	var item_amount = randi_range(1, 3);
	print(item_amount);
	
	for i in item_amount:
		var item = item_scene.instantiate();
		item.item_click = false;
		#add_child(item);
		order.append(item);
		order_list_box.add_child(item);
		order_list_box.move_child(item, i);

# Function to check if an order is complete

# 

func _physics_process(_delta: float):
	timer_bar.value = timer.wait_time - timer.time_left;

func _on_timer_timeout() -> void:
	# Delete itself and send +1 to failed orders
	queue_free(); # Replace with function body.
