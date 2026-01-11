extends Node2D

@onready var textbox = $DescriptionBox/DescriptionText;

const DESCRIPTIONS = {
	"music_generator1": "A music box. Generates Vocal Practice and Singing.",
	"music_item1": "Vocal Practice - “GUH.” Merge to Singing",
	"music_item2": "Singing - “Excuse My Rudeness, But Could You Please RIP?” Merge to Dance Lesson", 
	"music_item3": "Dance Lesson - “You made me dance next to horses. $%@# you. Die Gigi!” Merge to Lyric Writing", 
	"music_item4": "Lyric Writing - “GUH.” Merge to Song", 
	"music_item5": "Song - “” Merge to Album",
	"music_item6": "Album - “SINDERELLA.” Merge to Collaboration",
	"music_item7": "Collaboration - “Everybody loves the sound of the C-man.” Merge to Live Concert",
	"music_item8": "Live Concert - “HUGE W.” This is the max level" 
}

func _ready():
	global.update_description.connect(update_text);

func update_text(item: Item):
	var desc_string = "";
	var text_gen = "";
	
	if item.item_gen:
		text_gen = "generator";
	else:
		text_gen = "item";
		
	desc_string = item.item_type + "_" + text_gen + str(item.item_level);
	print(desc_string)
	if desc_string in DESCRIPTIONS:
		textbox.text = DESCRIPTIONS[desc_string];
	
