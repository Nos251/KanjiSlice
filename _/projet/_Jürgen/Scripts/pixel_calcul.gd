class_name PixelCounter
extends Node

## Compte les pixels d'une texture selon des critères de couleur et d'alpha.
## Retourne un Dictionary contenant les résultats.
static func analyze_layer_pixels(texture: Texture2D, alpha_threshold: float = 0.05, black_threshold: float = 0.05) -> Dictionary:
	var result = {
		"total_pixels": 0,
		"transparent_pixels": 0,
		"visible_pixels": 0,
		"black_pixels": 0,
		"other_pixels": 0
	}
	
	if not texture:
		push_error("PixelCounter: La texture fournie est vide (null).")
		return result
		
	# Extraire l'image de la texture pour pouvoir lire les pixels sur le CPU
	var image: Image = texture.get_image()
	if image.is_empty():
		return result
		
	var width = image.get_width()
	var height = image.get_height()
	result["total_pixels"] = width * height
	
	# Parcours de tous les pixels de l'image
	for y in range(height):
		for x in range(width):
			var pixel_color: Color = image.get_pixel(x, y)
			
			# 1. Vérification de l'Alpha (Transparence)
			if pixel_color.a <= alpha_threshold:
				result["transparent_pixels"] += 1
			else:
				result["visible_pixels"] += 1
				
				# 2. Vérification du Noir (proche de 0,0,0 sans compter l'alpha)
				# On utilise une tolérance (threshold) au cas où le noir n'est pas parfait (ex: 0.01)
				if pixel_color.r <= black_threshold and pixel_color.g <= black_threshold and pixel_color.b <= black_threshold:
					result["black_pixels"] += 1
				else:
					result["other_pixels"] += 1
					
	return result
