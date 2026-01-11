extends Node2D

@onready var textbox = $DescriptionBox/DescriptionText;

const DESCRIPTIONS = {
	"music_generator1": "It's a MUSIC BOX. Generates VOCAL PRACTICE and SINGING.",
	"music_item1": "VOCAL PRACTICE LEVEL 1 - “GUH.” Merge to become SINGING",
	"music_item2": "SINGING LEVEL 2 - “Excuse My Rudeness, But Could You Please RIP?” Merge to become DANCE LESSON", 
	"music_item3": "DANCE LESSON LEVEL 3 - “You made me dance next to horses. $%@# you. Die Gigi!” Merge to become LYRIC WRITING", 
	"music_item4": "LYRIC WRITING LEVEL 4 - “I'll never find my way back to you inside this labyrinth of lights.” Merge to become SONG", 
	"music_item5": "SONG LEVEL 5 - “Mori's in the building so you know you're already dead.” Merge to become ALBUM",
	"music_item6": "ALBUM LEVEL 6 - “SINDERELLA.” Merge to become COLLABORATION",
	"music_item7": "COLLABORATION LEVEL 7 - “Queen of the Night.” Merge to become LIVE CONCERT",
	"music_item8": "LIVE CONCERT LEVEL 8 - “HUGE W.” This is the max level." 
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
	
