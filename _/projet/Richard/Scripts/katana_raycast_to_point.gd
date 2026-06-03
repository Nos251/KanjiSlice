class_name KatanaRaycastToPoint
extends Node3D

@export var raycast_line : Array[RayCast3D] = []
@export var debug_point:Node3D
@export var debug_point_vector3:Vector3
@export var brush_color:Color
@export var clear_color:Color
var pixel_position : Vector2i
signal katana_is_touching(is_touching : bool)
signal katana_collision_point(global_point : Vector3)
signal on_drawing_called(image : Image)

var brush_radius : int 
var draw : bool
var clear : bool

func draw_with_percent_top_down(percentage01_in_vector2 : Vector3 ):
	pixel_position = Vector2i(percentage01_in_vector2.x,percentage01_in_vector2.y)

func button_press_to_draw_and_clear(name : String) -> void:
	if name == "trigger":
		draw = true
		clear = false
	if name == "by_button":
		draw = false
		clear = true
func button_release_to_draw_and_clear(name : String) -> void:
	if name == "trigger":
		draw = false
	if name == "by_button":
		clear = false
		
func _drawing(pixel_position : Vector2i, image : Image, color : Color, materiel : StandardMaterial3D, brush : Array[Vector2i]) -> void:
	var override_texture := ImageTexture.create_from_image(image)
	for offset in brush:
		var p : Vector2i = pixel_position + offset
		if p.x >=0 and p.x < image.get_width() and p.y >= 0 and p.y < image.get_height():
			image.set_pixelv(p, color)
			override_texture.update(image)
	on_drawing_called.emit(image)
	materiel.albedo_texture = override_texture

func replace_texture(color : Color) -> void:
	for r in raycast_line:
		if r.is_colliding():
			var collider = r.get_collider()
			var touch := r.get_collision_point()
			var object : Node3D = collider.get_parent()
			var mesh_instance := object as MeshInstance3D
			var material = mesh_instance.get_active_material(0)
			if material == null:
				print("no material")
				return
			material = material.duplicate()
			mesh_instance.set_surface_override_material(0, material)
			var texture = material.albedo_texture
			if texture is not Texture2D:
				print("not a 2D texture")
				return
			var image = texture.get_image()
			_drawing(pixel_position, image, brush_color, material,brush)
			
			debug_point_vector3 =touch
			if debug_point:
				debug_point.global_position = touch
				katana_collision_point.emit(touch)
				katana_is_touching.emit(true)
			return 
	katana_collision_point.emit(Vector3.ZERO)
	katana_is_touching.emit(false)
	

func _physics_process(delta):
		replace_texture(Color.BLACK)
		
