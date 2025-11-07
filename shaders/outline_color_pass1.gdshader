shader_type spatial;
render_mode unshaded;

const uint mask_layer_val = 1u;

uniform vec4 original_color : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if((CAMERA_VISIBLE_LAYERS & mask_layer_val) == mask_layer_val) {
		ALBEDO = original_color.rgb;
	} else {
		discard;
	}
}
