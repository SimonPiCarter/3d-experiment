shader_type spatial;
render_mode unshaded, depth_draw_opaque, depth_test_disabled;

uniform vec4 original_color : source_color;

void fragment() {
	ALBEDO = original_color.rgb;
	ALPHA_HASH_SCALE = 1.0;
	ALPHA = 1.0;
}
