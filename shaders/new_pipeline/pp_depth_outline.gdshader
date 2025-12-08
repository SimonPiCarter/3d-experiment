shader_type spatial;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D depth_texture : hint_depth_texture, repeat_disable, filter_nearest;

void vertex() {
  POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

float get_depth(vec2 uv, mat4 inv) {
	float depth = texture(depth_texture, uv).x;
	vec3 ndc = vec3(uv * 2.0 - 1.0, depth);
	vec4 view = inv * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z;
	return linear_depth;
}

void fragment() {
	vec4 screen_color = texture(screen_texture, SCREEN_UV);
	float linear_depth = get_depth(SCREEN_UV, INV_PROJECTION_MATRIX);
	ALBEDO = screen_color.rgb;
	ALBEDO.b = texture(depth_texture, SCREEN_UV).x;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
