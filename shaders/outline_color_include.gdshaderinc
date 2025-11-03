#ifdef SHADED
render_mode diffuse_toon, specular_toon, shadows_disabled;
#else
render_mode unshaded;
#endif
#ifdef NODEPTH
render_mode depth_test_disabled;
#endif

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
#ifndef NODEPTH
uniform sampler2D depth_texture : source_color, hint_depth_texture, filter_nearest;
#endif
uniform vec4 original_color : source_color;
uniform vec4 high_shape_color : source_color;
uniform vec4 low_shape_color : source_color;
uniform vec4 outline_color : source_color;
uniform float outline_width = 2.0;
uniform float glow_width = 20.0;
uniform bool constant_width = true;

#ifndef NODEPTH
float get_depth(vec2 screen_uv, mat4 inv_projection_matrix) {
	float depth = texture(depth_texture, screen_uv).r;
	vec3 ndc = vec3(screen_uv * 2.0 - 1.0, depth);
	vec4 view = inv_projection_matrix * vec4(ndc, 1.0);
	view.xyz /= view.w;
	return -view.z;
}
#endif

void fragment() {
	vec4 pixelatedtext = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec2 pixel_size = 1.0 / VIEWPORT_SIZE;
	vec3 old_albedo = ALBEDO;
	ALBEDO = pixelatedtext.rgb;
#ifndef NODEPTH
	float depth_ref = get_depth(SCREEN_UV, INV_PROJECTION_MATRIX);
#endif
	bool is_edge = false;
	for(int y = -1*int(outline_width); y <= 1*int(outline_width); y++)
	for(int x = -1*int(outline_width); x <= 1*int(outline_width); x++)
	{
		vec2 screen_uv = SCREEN_UV + vec2(float(x),float(y)) * pixel_size;
#ifndef NODEPTH
		float depth = get_depth(screen_uv, INV_PROJECTION_MATRIX);
		bool depth_test = depth_ref < depth;
#else
		bool depth_test = true;
#endif

		vec4 tex = texture(SCREEN_TEXTURE, screen_uv );
		float color_diff = length(tex.rgb - original_color.rgb);
		if((tex.a == 0.0 || (color_diff >= 0.001 && depth_test)) &&
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
		float min_dist = sqrt(2.*glow_width*glow_width);
		for(int y = -1*int(glow_width); y <= 1*int(glow_width); y++)
		for(int x = -1*int(glow_width); x <= 1*int(glow_width); x++)
		{
			vec2 screen_uv = SCREEN_UV + vec2(float(x),float(y)) * pixel_size;
#ifndef NODEPTH
			float depth = get_depth(screen_uv, INV_PROJECTION_MATRIX);
			bool depth_test = depth_ref < depth;
#else
			bool depth_test = true;
#endif
			vec4 tex = texture(SCREEN_TEXTURE, screen_uv );
			float color_diff = length(tex.rgb - original_color.rgb);
			if((tex.a == 0.0 || (color_diff >= 0.001 && depth_test)) &&
			SCREEN_UV.x + float(x) * pixel_size.x < 1.0 &&
			SCREEN_UV.x + float(x) * pixel_size.x > 0.0 &&
			SCREEN_UV.y + float(y) * pixel_size.y < 1.0 &&
			SCREEN_UV.y + float(y) * pixel_size.y > 0.0)
			{
				min_dist = min(min_dist, sqrt(float(x*x+y*y)));
			}
		}
		float high = min_dist/sqrt(2.*glow_width*glow_width);
		ALBEDO = high_shape_color.rgb * high + (1.-high) * low_shape_color.rgb;
		// ALBEDO = clamp(shape_color.rgb * pow(2.0, 1.0),vec3(0.0,0.0,0.0), vec3(1.0,1.0,1.0));
	}
}