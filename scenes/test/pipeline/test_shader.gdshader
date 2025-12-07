shader_type spatial;
render_mode unshaded, fog_disabled;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D depth_texture : hint_depth_texture, repeat_disable, filter_nearest;
uniform sampler2D normal_roughness_texture : hint_normal_roughness_texture, repeat_disable, filter_nearest;
uniform vec4 color : source_color;
const vec2[8] DIRECTIONS = {
	vec2(1.0, 0.0),
	vec2(0.0, 1.0),
	vec2(-1.0, 0.0),
	vec2(0.0, -1.0),
	vec2(1.0, 1.0),
	vec2(-1.0, 1.0),
	vec2(-1.0, -1.0),
	vec2(1.0, -1.0)
};

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

float get_surface_id(vec2 uv) {
	vec4 screen_color = texture(screen_texture, uv);
	return screen_color.r+screen_color.g+screen_color.b;
}

void fragment() {
	float linear_depth = get_depth(SCREEN_UV, INV_PROJECTION_MATRIX);

	vec4 normal_rough = texture(normal_roughness_texture, SCREEN_UV);
	vec3 normals_view_raw = normal_rough.xyz; // Normals in view space, in [0.0, 1.0] range
	vec3 normals_view_remapped = normals_view_raw.xyz * 2.0 - 1.0;  // Normals in view space, in [-1.0, 1.0] range
	normals_view_remapped /= length(normals_view_remapped);
	vec3 normals_world = (INV_VIEW_MATRIX * vec4(normals_view_remapped, 0.0)).xyz;
	float dot_p = abs(dot(normals_view_remapped, vec3(0,0,-1)));

	float surface_id = get_surface_id(SCREEN_UV);
	//ALBEDO = vec3(linear_depth/10., dot_p,0);

	vec2 pixel_size = 1./VIEWPORT_SIZE;
	float is_outline = 0.;
	for(int i = 0; i < 8; ++i) {
		vec2 uv = SCREEN_UV + DIRECTIONS[i]*pixel_size;
		float other_d = get_depth(uv, INV_PROJECTION_MATRIX);
		float other_id = get_surface_id(uv);
		is_outline += step(0.05 / dot_p * (linear_depth/10.), other_d - linear_depth) * (1.-step(0.01, abs(surface_id - other_id)));
		is_outline += step(0.01, surface_id - other_id);
	}
	is_outline = clamp(is_outline, 0., 1.);
	vec3 color_orig = texture(screen_texture, SCREEN_UV).rgb;
	float dot_light = dot(normals_world, vec3(0,-1,-1)/sqrt(2.));
	color_orig -= 0.2*color_orig* step(-0.1, dot_light);
	ALBEDO = color_orig*(1.-is_outline) + is_outline * color.rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
