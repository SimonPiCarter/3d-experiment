shader_type canvas_item;

uniform float rounding = 10.f;
uniform float outline_width = 1.f;
uniform vec4 outline_color : source_color;
uniform sampler2D color_texture;

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
		min(uv.x, rect.z-uv.x),
		min(uv.y, rect.w-uv.y));
	return step(rounding, max(pixel_dist.x, pixel_dist.y)) * (step(0., min(pixel_dist.x, pixel_dist.y)));
}

float get_alpha(vec2 uv, vec4 rect) {
	return clamp(
		get_corner_alpha(uv, vec2(rounding, rounding))
		+ get_corner_alpha(uv, vec2(rect.z,0.) + vec2(-rounding, rounding))
		+ get_corner_alpha(uv, vec2(rect.z, rect.w) + vec2(-rounding, -rounding))
		+ get_corner_alpha(uv, vec2(0.,rect.w) + vec2(rounding, -rounding))
		+ filler_alpha(uv, rect),
		0.,1.);
}

void fragment() {
	float is_outline = 0.;
	for (int i = 0; i < 4 * type; i++) {
		is_outline += (1.-get_alpha(UV + DIRECTIONS[i] * outline_width, REGION_RECT));
	}

	is_outline = step(0.5, is_outline);
	COLOR = outline_color * is_outline + (1.-is_outline) * texture(color_texture, UV/REGION_RECT.zw);
	COLOR.a = get_alpha(UV, REGION_RECT);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
