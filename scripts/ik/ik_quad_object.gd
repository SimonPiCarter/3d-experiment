class_name IKQuadObject extends Node3D

@export var FrontLeftLeg : IKAutoStart
@export var FrontRightLeg : IKAutoStart
@export var BackLeftLeg : IKAutoStart
@export var BackRightLeg : IKAutoStart
@export var Armature : Node3D
@export var Body : IKAutoStart
@export var BodyMarker : Marker3D

var body_tween : Tween = null
var ref_armature : Vector3
var ref_marker : Vector3

func _ready() -> void:
	if Armature:
		ref_armature = Armature.position
	if BodyMarker:
		ref_marker = BodyMarker.position

func get_materials_for_picker() -> Array[ShaderMaterial]:
	return []

func apply_force(force_in : Vector3, intensity = 5.) -> void:
	if not Armature or not BodyMarker:
		return
	if body_tween:
		body_tween.kill()
	force_in = get_parent().transform.basis.inverse() * force_in
	body_tween = get_tree().create_tween()
	var time = 1./intensity
	body_tween.tween_property(Armature, "position", ref_armature + force_in/3.*2., time).set_trans(Tween.TRANS_CUBIC)
	body_tween.parallel().tween_property(BodyMarker, "position", ref_marker+force_in, time).set_trans(Tween.TRANS_CUBIC)
	body_tween.tween_property(Armature, "position", ref_armature, time)
	body_tween.parallel().tween_property(BodyMarker, "position", ref_marker, time)
