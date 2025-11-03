shader_type canvas_item;

uniform vec4 outline_color : source_color;
uniform float outline_width = 1.0;
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

float gtz(float input) { return max(0, sign(input)); }
// returns 1 if input > 0, else 0

float check_alpha(sampler2D tex, vec2 from, vec2 size) {
	float result = 0.0;
	for (int i = 0; i < 4 * type; i++) {
		vec4 color = texture(tex, from + DIRECTIONS[i] * size * outline_width);
		result += color.a;
	}
	return gtz(result);
}

float check_color(sampler2D tex, vec2 from, vec2 size) {
	float result = 0.0;
	vec4 ref_color = texture(tex, from);
	float ref_val_color = ref_color.r+ref_color.g+ref_color.b;
	for (int i = 0; i < 4 * type; i++) {
		vec4 color = texture(tex, from + DIRECTIONS[i] * size * outline_width);
		float diff_color = abs(color.r - ref_color.r)
						 + abs(color.g - ref_color.g)
						 + abs(color.b - ref_color.b);
		float val_color = color.r+color.g+color.b;
		float diff = ref_val_color - val_color;
		float abs_diff = abs(diff);
		result += diff_color * (abs_diff - diff + 1.-color.a);
	}
	return result * ref_color.a;
}

void fragment() {
	COLOR = mix( COLOR, outline_color,
		check_color(TEXTURE, UV, TEXTURE_PIXEL_SIZE));
}