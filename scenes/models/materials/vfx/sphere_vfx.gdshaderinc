render_mode unshaded;
#ifdef NO_CULLING
render_mode cull_disabled;
#endif

const int outline_layer_val = 1<<4;

// Required uniforms in main shader (missing otherwise)
// uniform sampler2D Noise : source_color;
// uniform float Threshold : hint_range(0.0, 1.0) = 0.5;
// uniform float ThresholdAlpha : hint_range(0.0, 1.0) = 0.0;
// uniform vec4 ColorHigh : source_color = vec4(0.2, 1.0, 0.2, 0.5);
// uniform vec4 ColorLow : source_color = vec4(0.2, 1.0, 0.2, 0.5);
uniform float speed_offset : hint_range(0.0, 0.9) = 0.;
uniform float reversed : hint_range(0.0, 1.0, 1.0) = 0.;

// void vertex() {
// 	// Called for every vertex the material is visible on.
// }

void fragment() {
	// Real amplitude
	float amplitude = 1. - speed_offset;
	float center_length = (UV.x-0.5)*(UV.x-0.5)+(UV.y-0.5)*(UV.y-0.5);
	float max_length = 0.4*0.4+0.4*0.4;
	float ratio_length = center_length/max_length;
	float threshold = 1./amplitude * Threshold - 1./amplitude*speed_offset*(1.-ratio_length);
	float threshold_alpha = 1./amplitude * ThresholdAlpha - 1./amplitude*speed_offset*(1.-ratio_length);
	vec4 noise_tex = texture(Noise, UV);
	float step_val = step(threshold, noise_tex.r) * (1.-reversed) + step(noise_tex.r, threshold) * (reversed);
	float step_alpha_val = step(threshold_alpha, noise_tex.r) * (1.-reversed) + step(noise_tex.r, threshold_alpha) * (reversed);
	if((int(CAMERA_VISIBLE_LAYERS) & outline_layer_val) != 0) {
		ALBEDO = ColorLow.rgb/length(ColorLow) * step_val + ColorHigh.rgb * (1.-step_val);
	} else {
		ALBEDO = ColorLow.rgb * step_val + ColorHigh.rgb * (1.-step_val);
	}
	ALPHA = (ColorLow.a * step_val + ColorHigh.a * (1.-step_val)) * step_alpha_val;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
