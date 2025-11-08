render_mode unshaded;
#ifdef NO_CULLING
render_mode cull_disabled;
#endif

// Required uniforms in main shader (missing otherwise)
// uniform sampler2D Noise : source_color;
// uniform float Threshold : hint_range(0.0, 1.0) = 0.5;
// uniform float ThresholdAlpha : hint_range(0.0, 1.0) = 0.0;
// uniform vec4 ColorHigh : source_color = vec4(0.2, 1.0, 0.2, 0.5);
// uniform vec4 ColorLow : source_color = vec4(0.2, 1.0, 0.2, 0.5);

// void vertex() {
// 	// Called for every vertex the material is visible on.
// }

void fragment() {
	vec4 noise_tex = texture(Noise, UV);
	float step_val = step(Threshold, noise_tex.r);
	float step_alpha_val = step(ThresholdAlpha, noise_tex.r);
	ALBEDO = ColorLow.rgb * step_val + ColorHigh.rgb * (1.-step_val);
	ALPHA = (ColorLow.a * step_val + ColorHigh.a * (1.-step_val)) * step_alpha_val;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
