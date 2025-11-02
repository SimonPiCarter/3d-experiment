// source https://godotshaders.com/shader/clean-pixel-perfect-outline-via-material-3/

shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform sampler2D depth_texture : source_color, hint_depth_texture, filter_nearest;
uniform vec4 shape_color : source_color;
uniform vec4 outline_color : source_color;
uniform float outline_width = 2.0;
uniform bool constant_width = true;

float get_depth(vec2 screen_uv, mat4 inv_projection_matrix) {
	float depth = texture(depth_texture, screen_uv).r;
	vec3 ndc = vec3(screen_uv * 2.0 - 1.0, depth);
	vec4 view = inv_projection_matrix * vec4(ndc, 1.0);
	view.xyz /= view.w;
	return -view.z;
}

void fragment() {
	vec4 pixelatedtext = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec2 pixel_size = 1.0 / VIEWPORT_SIZE;
	vec3 old_albedo = ALBEDO;
	ALBEDO = pixelatedtext.rgb;
	float depth_ref = get_depth(SCREEN_UV, INV_PROJECTION_MATRIX);
	bool is_edge = false;
	for(int y = -1*int(outline_width); y <= 1*int(outline_width); y++)
	for(int x = -1*int(outline_width); x <= 1*int(outline_width); x++)
	{
		vec2 screen_uv = SCREEN_UV + vec2(float(x),float(y)) * pixel_size;
		float depth = get_depth(screen_uv, INV_PROJECTION_MATRIX);
		vec4 tex = texture(SCREEN_TEXTURE, screen_uv );
		if((tex.a == 0.0 || tex.r != 1.0) &&
		SCREEN_UV.x + float(x) * pixel_size.x < 1.0 &&
		SCREEN_UV.x + float(x) * pixel_size.x > 0.0 &&
		SCREEN_UV.y + float(y) * pixel_size.y < 1.0 &&
		SCREEN_UV.y + float(y) * pixel_size.y > 0.0)
		{
			is_edge = true;
		}
	}
	if(is_edge) {
		ALBEDO = outline_color.rgb;
		ALPHA = 1.0;
	} else {
		ALBEDO = shape_color.rgb;
	}

}