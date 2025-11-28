shader_type canvas_item;

uniform float rounding = 10.f;
uniform float outline_width = 1.f;
uniform float border_width = 0.f;
uniform vec4 outline_color : source_color;
uniform vec4 base_color : source_color;
uniform sampler2D color_texture;
uniform sampler2D border_texture;
uniform sampler2D mask;

uniform int type : hint_range(0, 2) = 2;

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
	// Called for every vertex the material is visible on.
}

float get_corner_alpha(vec2 uv, vec2 center) {
	vec2 centered_uv = (uv - center);
	return 1. - step(rounding*rounding, centered_uv.x*centered_uv.x + centered_uv.y*centered_uv.y);
}

float filler_alpha(vec2 uv, vec4 rect) {
	vec2 pixel_dist = vec2(
		min(uv.x-rect.x, rect.z-uv.x),
		min(uv.y-rect.y, rect.w-uv.y));
	return step(rounding, max(pixel_dist.x, pixel_dist.y)) * (step(0., min(pixel_dist.x, pixel_dist.y)));
}

float get_alpha(vec2 uv, vec4 rect) {
	return clamp(
		get_corner_alpha(uv, vec2(rect.x,rect.y) + vec2(rounding, rounding))
		+ get_corner_alpha(uv, vec2(rect.z,rect.y) + vec2(-rounding, rounding))
		+ get_corner_alpha(uv, vec2(rect.z, rect.w) + vec2(-rounding, -rounding))
		+ get_corner_alpha(uv, vec2(rect.x,rect.w) + vec2(rounding, -rounding))
		+ filler_alpha(uv, rect),
		0.,1.);
}

void fragment() {
	vec4 region_rect = REGION_RECT + vec4(border_width, border_width, -border_width, -border_width);
	float is_outline = 0.;
	for (int i = 0; i < 4 * type; i++) {
		is_outline += (1.-get_alpha(UV + DIRECTIONS[i] * outline_width, region_rect));
	}

	is_outline = step(0.5, is_outline);
	float orig_alpha = COLOR.a;
	COLOR = outline_color * is_outline + (1.-is_outline) * base_color * texture(color_texture, UV/region_rect.zw);
	COLOR.a = get_alpha(UV, region_rect) * orig_alpha;
	COLOR.rgb = mix(COLOR.rgb, COLOR.rgb*0.98, vec3(1,1,1)*step(0.5, texture(mask,SCREEN_UV).r));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
