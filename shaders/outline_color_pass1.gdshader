shader_type spatial;
render_mode unshaded, depth_test_disabled;

uniform vec4 original_color : source_color;

void fragment() {
	ALBEDO = original_color.rgb;
}
