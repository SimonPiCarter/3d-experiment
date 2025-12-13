class_name AnimationTrack extends Resource

@export var mesh : Mesh
@export var material : ShaderMaterial
@export var tracks : Array[Vector2i] = []
@export var forward : Vector3 = Vector3.FORWARD

@export var walking_anim : int = 0
@export var idle_anim : int = 0
@export var base_move_speed : float = 3.
