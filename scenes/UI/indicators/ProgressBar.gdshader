shader_type spatial;
render_mode unshaded;

uniform float ratio : hint_range(0.0, 1.0, 0.05) = 1.;
uniform sampler2D albedo_texture : source_color, filter_nearest;
uniform sampler2D mask_texture : source_color, filter_nearest;

uniform bool use_billboard;
void vertex() {
	if (use_billboard){
        MODELVIEW_MATRIX = VIEW_MATRIX * mat4(INV_VIEW_MATRIX[0], INV_VIEW_MATRIX[1], INV_VIEW_MATRIX[2], MODEL_MATRIX[3]);
	}
	VERTEX = VERTEX;
}

const uint mask_layer_val = 1u;
const uint outline_layer_val = 1u>>5u;

void fragment() {
	float mask = texture(mask_texture, UV).a;
	if((CAMERA_VISIBLE_LAYERS & mask_layer_val) == mask_layer_val) {
		vec4 color = texture(albedo_texture, UV);
		ALBEDO = color.rgb;
		ALPHA = (1.-step(ratio, UV.x)) * color.a * mask;
	} else if((CAMERA_VISIBLE_LAYERS & outline_layer_val) == outline_layer_val) {
		ALBEDO = vec3(0,0,0);
		ALPHA = mask;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
