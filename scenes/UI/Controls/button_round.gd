@tool 
class_name ButtonRound extends Control

@export var snap_rounding : bool = false
@export var rounding : float = 10.
@export var outline_width : float = 1.
@export var base_outline_color : Color = Color.GRAY
@export var hl_outline_color : Color = Color.WHITE
@onready var button_texture: TextureRect = $TextureRect2
@onready var shader = button_texture.material as ShaderMaterial

func _ready() -> void:
	shader.set_shader_parameter("outline_color", base_outline_color)

func _process(delta: float) -> void:
	if snap_rounding:
		shader.set_shader_parameter("rounding", size.y/2.)
	else:
		shader.set_shader_parameter("rounding", rounding)
	shader.set_shader_parameter("outline_width", outline_width)

func _on_mouse_exited() -> void:
	shader.set_shader_parameter("outline_color", base_outline_color)

func _on_mouse_entered() -> void:
	shader.set_shader_parameter("outline_color", hl_outline_color)
