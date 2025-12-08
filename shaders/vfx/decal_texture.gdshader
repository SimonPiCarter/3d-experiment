shader_type spatial;
render_mode unshaded, cull_disabled;

const int outline_layer_val = 1<<4;

uniform sampler2D albedo : filter_linear, source_color;
uniform vec4 color : source_color;

varying float depth;

void vertex() {
	vec3 vertex_view = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	depth = -vertex_view.z;
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 col = texture(albedo, UV);
	col.a = step(0.5, col.a);
	if((int(CAMERA_VISIBLE_LAYERS) & outline_layer_val) != 0) {
		ALBEDO = col.rgb * color.rgb/length(color);
		ALPHA = col.a * color.a * step(depth, 15.);
	} else {
		ALBEDO = col.rgb * color.rgb;
		ALPHA = col.a * color.a;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
