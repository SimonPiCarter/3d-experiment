shader_type spatial;

render_mode unshaded;

uniform sampler2D noise : source_color;
uniform vec4 high_shape_color : source_color;
uniform vec4 low_shape_color : source_color;
uniform float threshold = 0.5;
uniform float speed = 0.5;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float val = step(threshold, texture(noise, vec2(UV.x, UV.y - TIME * speed)).r);
	ALBEDO = val * high_shape_color.rgb + (1.-val) * low_shape_color.rgb;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
