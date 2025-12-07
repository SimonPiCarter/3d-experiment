shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D noise : repeat_enable, filter_linear, source_color;
uniform sampler2D threshold_offset : filter_linear, source_color;
uniform vec4 color : source_color;
uniform float threshold : hint_range(0.0, 1.0, 0.01)= 0.5;

const int outline_layer_val = 1<<4;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float a = 5.;
	float b = -3. * texture(threshold_offset, UV).r;
	float val = a * threshold + b;
	if((int(CAMERA_VISIBLE_LAYERS) & outline_layer_val) != 0) {
		ALBEDO = normalize(color.rgb);
	} else {
		ALBEDO = color.rgb;
	}
	ALPHA = step(texture(noise, UV*4.).r, val) * color.a;
}
