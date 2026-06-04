extends Node
@export var liste_scene : Array[PackedScene] = []
@export var button_play : Button
@export var button_quit : Button
var scene_random : PackedScene
func _ready():
	button_play.pressed.connect(_play_button_pressed)
	button_quit.pressed.connect(_quit_button_pressed)
	
func _play_button_pressed():
	scene_random = liste_scene.pick_random()
	if scene_random:
		get_tree().change_scene_to_packed(scene_random)
	else:
		print("Erreur : scene_random n'est pas assignée !")
func _quit_button_pressed() :
	get_tree().quit()
