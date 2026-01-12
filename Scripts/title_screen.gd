extends Control

@onready var title = get_node("TitleText")
@onready var menu = get_node("MenuButtons")
@onready var introScreen = get_node("IntroScreen")
@onready var tutorialScreen = get_node("TutorialScreen")
@onready var creditsScreen = get_node("CreditsScreen")
@onready var backButton = get_node("Back/BackButton")


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainGame.tscn")

func _on_intro_pressed() -> void:
	title.hide()
	menu.hide()
	introScreen.show()
	backButton.show()

func _on_tutorial_pressed() -> void:
	title.hide()
	menu.hide()
	tutorialScreen.show()
	backButton.show()

func _on_credits_pressed() -> void:
	title.hide()
	menu.hide()
	creditsScreen.show()
	backButton.show()

func _on_back_pressed() -> void:
	introScreen.hide()
	tutorialScreen.hide()
	creditsScreen.hide()
	backButton.hide()
	title.show()
	menu.show()
