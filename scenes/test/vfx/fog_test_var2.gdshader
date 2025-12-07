shader_type spatial;
render_mode unshaded;

uniform sampler2D noise_1 : filter_linear;
uniform sampler2D noise_2 : filter_linear;
uniform float speed_1 = 1.;
uniform float speed_2 = 2.;
uniform vec2 dir_1 = vec2(1,0);
uniform vec2 dir_2 = vec2(1,0);
uniform vec4 color_1 : source_color;
uniform vec4 color_2 : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 col_1 = texture(noise_1, UV + dir_1 * TIME * speed_1);
	vec4 col_2 = texture(noise_1, UV + dir_2 * TIME * speed_2);
	float val = col_1.r + col_2.r;
	float st = step(1.25, val);
	ALBEDO = color_2.rgb * st + (1.-st) * color_1.rgb;
	//ALPHA = color_2.a * st + (1.-st) * color_1.a;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
