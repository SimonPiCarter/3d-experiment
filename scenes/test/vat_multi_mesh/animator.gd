extends Node3D

@export var vat_multi_mesh_instance_3d: VATMultiMeshInstance3D

var node3D: Node3D = Node3D.new()
var location: Vector3 = Vector3.ZERO
var x: float = -37
@export var start_x: float = -37
@export var max_x: float = 40
@export var z: float = -45
@export var spacing : Vector2 = Vector2(9,7.5)

func _ready() -> void:
	# setup all instancess
	setupInstances()

func setupInstances():
	var a: int = 1 # animation track number
	for instance in vat_multi_mesh_instance_3d.multimesh.instance_count:
		# randomize the animation offset
		vat_multi_mesh_instance_3d.update_instance_animation_offset(instance, randf())
		# set the animation track number
		vat_multi_mesh_instance_3d.update_instance_track(instance, a)
		# set alpha to 1.0 -> you can fade out a specific instance by setting alpha to 0
		vat_multi_mesh_instance_3d.update_instance_alpha(instance, 1.0)
		# randomize scale, rotation, and location
		randomizeInstance(instance)
		
		# Unit tests for helper functions - you can comment this out
		#print("Instance: ", instance, "   Track: ", vat_multi_mesh_instance_3d.get_track_number_from_instance(instance), \
			#"   Frame Start/End:", vat_multi_mesh_instance_3d.get_start_end_frames_from_instance(instance), \
			#"   Test Vector2i: ", vat_multi_mesh_instance_3d.get_start_end_frames_from_track_number(a) == vat_multi_mesh_instance_3d.get_start_end_frames_from_instance(instance), \
			#"   Test Track: ", vat_multi_mesh_instance_3d.get_track_number_from_track_vector(vat_multi_mesh_instance_3d.get_start_end_frames_from_track_number(a)) == vat_multi_mesh_instance_3d.get_track_number_from_instance(instance))

		# this cycles threw each animation track number
		a += 1
		if a > vat_multi_mesh_instance_3d.number_of_animation_tracks - 1:
			a = 0
		
func randomizeInstance(i: int):
	node3D.scale = Vector3(1,1,1)
		
	location.x = x
	location.z = z
	location.y = 0

	x += spacing.x
	if x > max_x:
		x = start_x
		z += spacing.y

	node3D.rotation = Vector3.ZERO
	node3D.position = location

	vat_multi_mesh_instance_3d.multimesh.set_instance_transform(i, node3D.transform)

var direction : float = 1.
var cur_rot = 0.;

func _input(event) -> void:
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_E:
		direction *= -1.;

func _process(delta: float) -> void:
	if vat_multi_mesh_instance_3d.instance_count > 1:
		return
	if direction < 0. and cur_rot < PI:
		cur_rot += 2.*PI*delta
		cur_rot = min(PI, cur_rot)
		node3D.rotation.y = cur_rot
	vat_multi_mesh_instance_3d.multimesh.set_instance_transform(0, node3D.transform)
	if direction > 0. and cur_rot > 0.:
		cur_rot -= 2.*PI*delta
		cur_rot = max(0, cur_rot)
		node3D.rotation.y = cur_rot
	vat_multi_mesh_instance_3d.multimesh.set_instance_transform(0, node3D.transform)
	position.z += 4.*0.3*delta*5.*direction
