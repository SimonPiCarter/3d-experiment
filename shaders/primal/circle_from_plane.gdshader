shader_type spatial;

render_mode unshaded;

uniform float ray = 0.3;
uniform float width = 0.1;
uniform float outline = 0.1;
uniform vec4 color : source_color = vec4(0.2, 1.0, 0.2, 1.);
uniform vec4 ouline_color : source_color = vec4(0.1, 0.5, 0.1, 1.);

const uint mask_layer_val = 1u;
const uint outline_layer_val = 1u>>5u;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 position = UV - vec2(0.5,0.5);
	float dist_to_center = position.x*position.x + position.y*position.y;
	float start_circle = ray-width;
	float end_circle = ray+width;
	float draw = step(start_circle*start_circle, dist_to_center) *
		(1.-step(end_circle*end_circle, dist_to_center));
	float draw_outline = step((start_circle-outline)*(start_circle-outline), dist_to_center) *
		(1.-step((start_circle+outline)*(start_circle+outline), dist_to_center)) +
		step((end_circle-outline)*(end_circle-outline), dist_to_center) *
		(1.-step((end_circle+outline)*(end_circle+outline), dist_to_center));
	ALPHA = draw + draw_outline;
	if((CAMERA_VISIBLE_LAYERS & mask_layer_val) == mask_layer_val) {
		ALBEDO = draw*color.rgb + draw_outline*ouline_color.rgb;
		ALPHA = ALPHA*draw*color.a + ALPHA*draw_outline*ouline_color.a;
	}
	else if((CAMERA_VISIBLE_LAYERS & outline_layer_val) == outline_layer_val) {
		ALBEDO = (draw + draw_outline)*ouline_color.rgb;
	} else {
		discard;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
