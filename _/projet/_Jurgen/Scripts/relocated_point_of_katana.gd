class_name RelocatedPointOfKatana

extends Node
## ceteedhcvgjhfjhkg frtertsfgf k100
signal local_percentage_emit(vector3: Vector3)
signal on_local_position_debug(text:String)
@export var down_left : Node3D 
@export var top_right : Node3D 
@export var point_of_katana : Vector3 
@export var local_position_of_katana : Vector3
@export var local_position_of_katana_unity : Vector3
@export var local_width_height : Vector3
@export var pixel_counter : PixelCounter
@export var points_for_kanji_cut_in_percent : float
@export var bonus_point_based_on_alpha : float
@export var total_score_in_percent : float
var mon_calque : Texture2D
var stats : Dictionary
var end_pixel_alpha : int
var end_pixel_black : int
var origin_pixel_alpha : int
var origin_pixel_black : int
@export var remaining_pixels_in_pourcent : float
@export var bonus_point_alpha : float

@export var katana_percentage_x : float
@export var katana_percentage_y : float
# Called when the node enters the scene tree for the first time.

func set_point_of_katana(katana : Vector3):
	point_of_katana = katana
func _ready() -> void:
	
	mon_calque = pixel_counter.kanji
	stats = pixel_counter.analyze_layer_pixels(mon_calque)
	
	#print("--- Analyse du Calque ---")
	#print("Total pixels : ", stats.total_pixels)
	#print("Pixels Invisibles (Alpha) : ", stats.transparent_pixels)
	#print("Pixels Visibles : ", stats.visible_pixels)
	#print("Pixels Noirs détectés : ", stats.black_pixels)
	
	origin_pixel_alpha = stats["transparent_pixels"]
	origin_pixel_black = stats["black_pixels"]
	
	#print("Original Pixel Invisible : ", origin_pixel_alpha)
	#print("Original Pixel Black :", origin_pixel_black)
	end_of_level_script()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	local_position_of_katana = relocate_global_to_local(point_of_katana)
	#DebugDraw3D.draw_line(Vector3(0,0,0),local_position_of_katana,Color.YELLOW)
	#
	#DebugDraw3D.draw_line(Vector3(0,0,0),Vector3(1,0,0),Color.RED)
	#DebugDraw3D.draw_line(Vector3(0,0,0),Vector3(0,1,0),Color.GREEN)
	#DebugDraw3D.draw_line(Vector3(0,0,0),Vector3(0,0,-1),Color.BLUE)
	var l : Vector3 = down_left.global_position
	#DebugDraw3D.draw_line(l ,l + down_left.global_basis.x,Color.RED)
	#DebugDraw3D.draw_line(l ,l + down_left.global_basis.y,Color.GREEN)
	#DebugDraw3D.draw_line(l ,l + -down_left.global_basis.z,Color.BLUE)
	
	local_position_of_katana_unity =local_position_of_katana
	local_position_of_katana_unity.z*=-1
	on_local_position_debug.emit(str(local_position_of_katana_unity))


	# 1. On calcule la taille de la zone de dessin en local
	# Comme down_left est le repère (0,0,0), top_right en local donne directement la Largeur/Hauteur !
	local_width_height = relocate_global_to_local(top_right.global_position)

	# 2. Sécurité anti-division par zéro au cas où les nodes seraient mal placés
	if local_width_height.x != 0 and local_width_height.z != 0:
		# CALCUL DU POURCENTAGE (Option Ratio : de 0.0 à 1.0)
		# Si tu veux entre 0% et 100%, rajoute " * 100.0 " à la fin des lignes en dessous
		katana_percentage_x = (local_position_of_katana_unity.x / local_width_height.x)
		katana_percentage_y = (local_position_of_katana_unity.z / local_width_height.z)
	else:
		katana_percentage_x = 0.0
		katana_percentage_y = 0.0

	# 3. On range ça dans ton Vector3 pour l'inspecteur ou l'affichage
	var local_percentage : Vector3 = Vector3(katana_percentage_x,0.0, katana_percentage_y,)
	#print("katana : ", local_position_of_katana_unity.x, ". local : ", local_width_height.x)
	#print("Position Katana en % : ", local_percentage)
	local_percentage_emit.emit(local_percentage) 
	
func relocate_global_to_local(global_point : Vector3) :
	var local_point = global_point -down_left.global_position  
	var local_direction = Quaternion.from_euler(down_left.global_rotation).inverse()*local_point
	#local_direction.z*=-1
	return local_direction
	
func end_of_level_script():
	#Calcul pourcentage for pixel colored black and alpha.
	end_pixel_alpha = stats["transparent_pixels"]
	end_pixel_black = stats["black_pixels"]
	bonus_point_alpha = (float(origin_pixel_alpha)/float(end_pixel_alpha))*100 
	remaining_pixels_in_pourcent = (float(end_pixel_black)/float(origin_pixel_black))*100
	points_for_kanji_cut_in_percent = 100 - remaining_pixels_in_pourcent
	bonus_point_based_on_alpha = bonus_point_alpha
	total_score_in_percent = (bonus_point_based_on_alpha + points_for_kanji_cut_in_percent)/2
	#(terminer la fonction en calculant le % de reussite 100 - offset,... et ensuite addition des deux et mise
	
	total_score_in_percent = int(total_score_in_percent)
	
	
	
	
