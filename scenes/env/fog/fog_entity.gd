class_name FogEntity extends Node3D

@export var fog_size : Vector2 = Vector2(10.,10.)
@export_range(1, 2, 1) var height : int = 1
@export_range(0, 50, 1) var small_fog : int = 10
@onready var plane = $Plane
@onready var spheres = $Spheres
@onready var multi_mesh_instance_3d = $MultiMeshInstance3D

var offsets : Array[float]
var transforms : Array[Transform3D]

func _ready():
	update()

func _validate_property(property: Dictionary): # update the config warnings
	if property.name == "fog_size":
		update()

var instance = 0
func spanw_sphere(x, y, h):
	#var scene = preload("res://scenes/test/vfx/fog_unit.tscn").instantiate()
	#spheres.add_child(scene)
	#scene.position.x = x
	#scene.position.z = y
	#scene.position.y = h
	#scene.scale = Vector3.ONE * 10.
	var trans = Transform3D()
	trans = trans.scaled(Vector3.ONE*10.)
	trans = trans.translated(Vector3(x,h,y))
	multi_mesh_instance_3d.multimesh.set_instance_transform(instance, trans)
	transforms.append(trans)
	offsets.append(randf_range(0, 2.*PI))
	instance += 1

func update():
	plane.scale.x = fog_size.x
	plane.scale.z = fog_size.y
	for child in spheres.get_children():
		child.queue_free()

	if not multi_mesh_instance_3d: return

	var nb_instance = height * 2* (fog_size.x / 5. + fog_size.y / 5. + 2) + small_fog
	instance = 0
	transforms.clear()
	offsets.clear()
	multi_mesh_instance_3d.multimesh.instance_count = 0
	multi_mesh_instance_3d.multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multi_mesh_instance_3d.multimesh.instance_count = nb_instance
	var trans = Transform3D()
	trans = trans.scaled(Vector3.ONE*10.)
	trans = trans.translated(Vector3(fog_size.x, 0., fog_size.y))
	multi_mesh_instance_3d.multimesh.set_instance_transform(0, trans)

	# spawn x axis fog
	var x = -fog_size.x/2.
	while x < fog_size.x/2.:
		for h in height:
			spanw_sphere(x + 2.5, -fog_size.y/2. + randf_range(-1.25, 1.25) - h*2.5, -2.5*h)
			spanw_sphere(x + 2.5, fog_size.y/2. + randf_range(-1.25, 1.25) + h*2.5, -2.5*h)
		x += 5.

	# spawn y axis fog
	var y = -fog_size.y/2.
	while y < fog_size.y/2.:
		for h in height:
			spanw_sphere(-fog_size.x/2. + randf_range(-1.25, 1.25) - h*2.5, y+2.5, -2.5*h)
			spanw_sphere(fog_size.x/2. + randf_range(-1.25, 1.25) + h*2.5, y+2.5, -2.5*h)
		y += 5.
	# spawn small entities
	var i = 0.
	while i < small_fog:
		var side_x = -1. if randi_range(0,1) == 0 else 1.
		var side_y = -1. if randi_range(0,1) == 0 else 1.
		var var_x = randi_range(0,1)
		var var_y = 1.-var_x
		x = side_x * (fog_size.x/2. + 10. - randf_range(0., fog_size.x +20.) * var_x)
		y = side_y * (fog_size.y/2. + 10. - randf_range(0., fog_size.y +20.) * var_y)
		spanw_sphere(x + randf_range(-1.25, 1.25), y + randf_range(-1.25, 1.25), -1.5 - 2.5*height - randf_range(1.5, 2.))

		i += 1.

var elapsed = 0.
func _process(delta):
	elapsed += delta*2.
	for i in transforms.size():
		var new_trans = transforms[i].scaled_local(Vector3.ONE*(1.+cos(offsets[i] + elapsed)*cos(offsets[i] + elapsed)/10.))
		multi_mesh_instance_3d.multimesh.set_instance_transform(i, new_trans)
	while elapsed > 10.*PI:
		elapsed -= 2.*PI
