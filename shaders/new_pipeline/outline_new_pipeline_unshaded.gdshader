shader_type spatial;
render_mode unshaded;

const uint mask_layer_val = 1u;
const uint outline_layer_val = 1u>>5u;

uniform vec4 original_color : source_color;
uniform vec4 outline_color : source_color = vec4(0.5,0.5,0.5,1.);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if((CAMERA_VISIBLE_LAYERS & mask_layer_val) == mask_layer_val) {
		ALBEDO = original_color.rgb;
	} else if((CAMERA_VISIBLE_LAYERS & outline_layer_val) == outline_layer_val) {
		ALBEDO = outline_color.rgb;
	} else {
		discard;
	}
}
