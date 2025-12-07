shader_type spatial;
render_mode unshaded, cull_disabled;

const int outline_layer_val = 1<<4;

uniform sampler2D albedo : filter_linear, source_color;
uniform vec4 color : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 col = texture(albedo, UV);
	col.a = step(0.5, col.a);
	if((int(CAMERA_VISIBLE_LAYERS) & outline_layer_val) != 0) {
		ALBEDO = col.rgb * color.rgb/length(color);
	} else {
		ALBEDO = col.rgb * color.rgb;
	}
	ALPHA = col.a * color.a;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
