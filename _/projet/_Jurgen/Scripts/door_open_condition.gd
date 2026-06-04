extends Node

var score_in_percent : int
@export var relocated_point_of_katana_script : RelocatedPointOfKatana
@export var sucess_treshold : int
var door_open : bool = false
@export var button_check_score : Button

func _ready():
	button_check_score.pressed.connect(_condition_check)
	
func _condition_check():
	score_in_percent = relocated_point_of_katana_script.total_score_in_percent
	print (score_in_percent)

	if score_in_percent >= sucess_treshold :
		door_open = true
		
	else :
		door_open = false
		


#get_tree().change_scene_to_packed(scene_main)
