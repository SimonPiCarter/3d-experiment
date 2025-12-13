@tool
class_name VatMeshInstance extends MeshInstance3D

@export var animation_tracks : AnimationTrack = null:
	set(value):
		animation_tracks = value
		update()
@export var animation : int = 0 :
	set(value):
		animation = value
		update()
@export var animation_speed : float = 1.0:
	set(value):
		animation_speed = value
		update()
@export var animation_offset : float = 0.0:
	set(value):
		animation_offset = value
		update()

func _ready() -> void:
	update()

func _get_configuration_warnings(): # display the warning on the scene dock
	var warnings = []
	if !animation_tracks:
		warnings.push_back('Animation Tracks not set')
	elif not animation_tracks.resource_local_to_scene:
		warnings.push_back('Animation Tracks must be local to scene')
	return warnings

func _validate_property(property: Dictionary): # update the config warnings
	if property.name == "animation_tracks":
		update_configuration_warnings()
		update()

func update() -> void:
	self.mesh = animation_tracks.mesh
	self.material_override = animation_tracks.material.duplicate()
	#self.material_override.resource_local_to_scene = true
	set_current_animation()

func set_current_animation() -> void:
	if animation < 0 or animation >= animation_tracks.tracks.size():
		printerr("VatAnimationEntity: Invalid track number: ", animation)
		return

	if animation_tracks:
		self.material_override.set_shader_parameter("start_frame", animation_tracks.tracks[animation].x)
		self.material_override.set_shader_parameter("end_frame", animation_tracks.tracks[animation].y)
		self.material_override.set_shader_parameter("animation_offset", animation_offset)
		self.material_override.set_shader_parameter("fps", 24.*animation_speed) # assuming 24 fps for VAT
