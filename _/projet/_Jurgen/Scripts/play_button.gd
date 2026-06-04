extends Node

@export var button_play : Button
@export var scene_main : PackedScene
@export var button_quit : Button
func _ready():
	button_play.pressed.connect(_play_button_pressed)
	button_quit.pressed.connect(_quit_button_pressed)
func _play_button_pressed():
	if scene_main:
		get_tree().change_scene_to_packed(scene_main)
	else:
		print("Erreur : scene_main n'est pas assignée !")
func _quit_button_pressed() :
	get_tree().quit()
