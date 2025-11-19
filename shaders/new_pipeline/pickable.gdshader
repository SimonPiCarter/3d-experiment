shader_type spatial;

render_mode unshaded;

const int pickable_layer_val = 1<<5;

uniform vec4 pickable_color : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if((int(CAMERA_VISIBLE_LAYERS) & pickable_layer_val) != 0) {
		ALBEDO = pickable_color.rgb;
	} else {
		discard;
	}
}
