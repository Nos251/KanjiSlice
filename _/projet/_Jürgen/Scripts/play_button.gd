extends Node

@export var button_play : Button
@export var scene_main : PackedScene

func _ready():
	button_play.pressed.connect(_button_pressed)
	
func _button_pressed():
	if scene_main:
		get_tree().change_scene_to_packed(scene_main)
	else:
		print("Erreur : scene_main n'est pas assignée !")
