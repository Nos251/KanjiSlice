extends Node3D

@export var raycast_line : Array[RayCast3D] = []
@export var debug_point:Node3D
@export var debug_point_vector3:Vector3
signal katana_is_touching(is_touching : bool)
signal katana_collision_point(global_point : Vector3)

func _physics_process(delta):
	
	for r in raycast_line:
		if r.is_colliding():
			var touch := r.get_collision_point()
			debug_point_vector3 =touch
			if debug_point:
				debug_point.global_position = touch
				katana_collision_point.emit(touch)
				katana_is_touching.emit(true)
			return 
	katana_collision_point.emit(Vector3.ZERO)
	katana_is_touching.emit(false)
