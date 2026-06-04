class_name DrawingScript
extends Node3D

var brush_color:Color = Color.CRIMSON
@export var clear_color:Color
@export var painting_board : MeshInstance3D
@export var width : int = 128
@export var heigth : int = 128
@export var pixel_position_inverse_y : Vector2i
@export var pixel_position : Vector2i
@export var is_drawing : bool
@export var recieved_position_in_percent : Vector3
@export_range(1,20)var brush_radius : int = 3 

#signal on_drawing_called(image : Image)

var img_builder : Image
var tex : ImageTexture
var material : StandardMaterial3D


func set_is_drawing(is_touching : bool):
	is_drawing = is_touching
	
func _ready() -> void:
	img_builder = Image.create(width, heigth, false, Image.FORMAT_RGBA8)
	img_builder.fill(Color.GREEN)
	tex = ImageTexture.create_from_image(img_builder)
	material = painting_board.get_surface_override_material(0)
	material.albedo_texture = tex

	
var brush : Array[Vector2i] = [Vector2i(0,0),Vector2i(1,0),Vector2i(0,1),Vector2i(-1,0),Vector2i(0,-1)]
var draw : bool
var clear : bool

func set_cursor_position(percentage01_in_vector2 : Vector3):
	pixel_position_inverse_y = Vector2i(percentage01_in_vector2.x*width,(1.0-percentage01_in_vector2.z)*heigth)
	pixel_position = Vector2i(percentage01_in_vector2.x*width,percentage01_in_vector2.z*heigth)
	recieved_position_in_percent = percentage01_in_vector2

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
	for offset in brush:
		var p : Vector2i = pixel_position + offset
		if p.x >=0 and p.x < image.get_width() and p.y >= 0 and p.y < image.get_height():
			image.set_pixelv(p, color)
			tex.update(image)
	materiel.albedo_texture = tex
	
func _physics_process(delta):
		_drawing(pixel_position_inverse_y, img_builder, brush_color, material,brush)
		
