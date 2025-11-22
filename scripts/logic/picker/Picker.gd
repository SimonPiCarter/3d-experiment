extends Node

var next_id : int = 0
var max_id : int = 255*255*255

var registered_pickables : Array[Node3D] = []

func get_next_id() -> int:
	var id = next_id
	next_id += 1
	if next_id > max_id:
		next_id = 0
	return id

func id_to_color(id: int) -> Color:
	var r : int = id % 256;
	var g : int = (id / 256 ) % 256;
	var b : int = (id / (256*256) ) % 256;
	return Color(r/255., g/255., b/255., 1.0)

func color_to_id(color: Color) -> int:
	var r : int = int(color.r * 255)
	var g : int = int(color.g * 255)
	var b : int = int(color.b * 255)
	if color.a > 0.5:
		return r + g *256 + b *256*256;
	return -1

func register_new_pickable(id:int, node: Node3D) -> void:
	if node in registered_pickables:
		return
	if id == registered_pickables.size():
		registered_pickables.append(node)
	else:
		registered_pickables[id] = node
	if node is QuadEntity and node.quad_object:
		for material in node.quad_object.get_materials_for_picker():
			var next_pass = material.next_pass
			if next_pass is ShaderMaterial:
				set_up_material(id, next_pass as ShaderMaterial)

func set_up_material(id:int, mat: ShaderMaterial) -> void:
	var pickable_color = id_to_color(id)
	mat.set_shader_parameter("pickable_color", pickable_color)

func get_node_from_texture(tex: Texture2D, x: int, y: int) -> Node3D:
	var img : Image = tex.get_image()
	var color : Color = img.get_pixel(x, y)
	var id : int = color_to_id(color)
	print("Picked color: ", color, " id: ", id)
	if id >= 0 and id < registered_pickables.size():
		return registered_pickables[id]
	return null

func get_nodes_from_texture(tex: ImageTexture, rect:Rect2i) -> Array[Node3D]:
	var img : Image = tex.get_image()
	var found_nodes : Array[Node3D] = []
	for dx in rect.size.x:
		var x = rect.position.x + dx
		for dy in rect.size.y:
			var y = rect.position.y + dy
			var color : Color = img.get_pixel(x, y)
			var id : int = color_to_id(color)
			if id >= 0 and id < registered_pickables.size():
				var node = registered_pickables[id]
				if node not in found_nodes:
					found_nodes.append(node)
	return found_nodes
