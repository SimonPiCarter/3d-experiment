shader_type spatial;

render_mode unshaded;

uniform sampler2D gradient_texture : filter_linear;
uniform vec4 color : source_color;
uniform float low_pass : hint_range(0.0, 1.0, 0.01);
uniform float high_pass : hint_range(0.0, 1.0, 0.01);
uniform float margin : hint_range(0.0, 1.0, 0.01);

const int mask_layer_val = 1;
const int outline_layer_val = 1<<4;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = color.rgb;
	float grad = texture(gradient_texture, UV).r;
	if((int(CAMERA_VISIBLE_LAYERS) & mask_layer_val) != 0) {
		ALPHA = color.a * smoothstep(low_pass-margin, low_pass, grad) * step(grad, high_pass);
	} else if((int(CAMERA_VISIBLE_LAYERS) & outline_layer_val) != 0) {
		ALPHA = color.a * step(grad, high_pass);
	} else {
		discard;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
