extends Node

@export var liste_scene : Array[PackedScene] = []

@export var button_play : Button
@export var button_quit : Button

# On va chercher le conteneur 3D de manière sécurisée en remontant les parents
var conteneur_jeu : Node3D = null

func _ready():
	# Liaison des boutons
	if button_play:
		button_play.pressed.connect(_play_button_pressed)
	if button_quit:
		button_quit.pressed.connect(_quit_button_pressed)
	
	# On cherche "Scene_Loading" dans l'arbre pour trouver le bon Node3D
	var scene_loading = trouver_parent_par_nom(self, "Scene_Loading")
	if scene_loading:
		# Une fois qu'on a la racine, on attrape le Node3D qui sert de conteneur
		conteneur_jeu = scene_loading.get_node_or_null("Node3D")

func _play_button_pressed():
	if !conteneur_jeu:
		print("Erreur : Impossible de trouver le Node3D conteneur depuis l'UI 2D !")
		return

	if liste_scene.size() == 0:
		print("Erreur : La liste_scene est vide dans l'inspecteur !")
		return
		
	var scene_random = liste_scene.pick_random()
	if scene_random:
		# 1. On détruit TOUT ce qui est dans le conteneur (donc le Viewport2Din3D actuel)
		for enfant in conteneur_jeu.get_children():
			enfant.queue_free()
			
		print("Menu effacé, chargement du niveau...")
		
		# 2. On injecte la nouvelle scène de jeu
		var nouvelle_scene = scene_random.instantiate()
		conteneur_jeu.add_child(nouvelle_scene)
	else:
		print("Erreur : Impossible de choisir une scène.")

func _quit_button_pressed():
	get_tree().quit()

# Petite fonction utilitaire pour remonter l'arborescence facilement
func trouver_parent_par_nom(noeud_depart: Node, nom_recherche: String) -> Node:
	var p = noeud_depart.get_parent()
	while p != null:
		if p.name == nom_recherche:
			return p
		p = p.get_parent()
	return null
