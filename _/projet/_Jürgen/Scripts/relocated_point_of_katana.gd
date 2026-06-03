extends Node

signal on_local_position_debug(text:String)
@export var down_left : Node3D 
@export var top_right : Node3D 
@export var point_of_katana : Node3D 
@export var local_position_of_katana : Vector3
@export var local_position_of_katana_unity : Vector3
@export var local_width_height : Vector3
@export var mon_calque : Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Appel du script indépendant
	var stats = PixelCounter.analyze_layer_pixels(mon_calque)
	
	# Affichage des résultats
	print("--- Analyse du Calque ---")
	print("Total pixels : ", stats.total_pixels)
	print("Pixels Invisibles (Alpha) : ", stats.transparent_pixels)
	print("Pixels Visibles : ", stats.visible_pixels)
	print("Pixels Noirs détectés : ", stats.black_pixels)
	
	local_position_of_katana = relocate_global_to_local(point_of_katana.global_position)
	DebugDraw3D.draw_line(Vector3(0,0,0),local_position_of_katana,Color.YELLOW)
	
	DebugDraw3D.draw_line(Vector3(0,0,0),Vector3(1,0,0),Color.RED)
	DebugDraw3D.draw_line(Vector3(0,0,0),Vector3(0,1,0),Color.GREEN)
	DebugDraw3D.draw_line(Vector3(0,0,0),Vector3(0,0,-1),Color.BLUE)
	var l : Vector3 = down_left.global_position
	DebugDraw3D.draw_line(l ,l + down_left.global_basis.x,Color.RED)
	DebugDraw3D.draw_line(l ,l + down_left.global_basis.y,Color.GREEN)
	DebugDraw3D.draw_line(l ,l + -down_left.global_basis.z,Color.BLUE)
	
	local_position_of_katana_unity =local_position_of_katana
	local_position_of_katana_unity.z*=-1
	on_local_position_debug.emit(str(local_position_of_katana_unity))


#autre chose
	local_width_height = relocate_global_to_local(top_right.global_position)

func relocate_global_to_local(global_point : Vector3) :
	var local_point = global_point -down_left.global_position  
	var local_direction = Quaternion.from_euler(down_left.global_rotation).inverse()*local_point
	#local_direction.z*=-1
	return local_direction
