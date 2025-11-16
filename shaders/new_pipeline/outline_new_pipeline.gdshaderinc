#ifdef SHADED
render_mode diffuse_toon, specular_toon, shadows_disabled;
#else
render_mode unshaded;
#endif
#ifdef NODEPTH
render_mode depth_test_disabled;
#endif


const uint mask_layer_val = 1u;
const uint outline_layer_val = 1u>>5u;

uniform vec4 original_color : source_color;
uniform vec4 outline_color : source_color = vec4(0.5,0.5,0.5,1.);
uniform sampler2D outline_mask : filter_nearest;
uniform bool use_mask = false;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if((CAMERA_VISIBLE_LAYERS & mask_layer_val) == mask_layer_val) {
		ALBEDO = original_color.rgb;
		#ifdef USE_ALPHA
		ALPHA = original_color.a;
		#endif
	} else if((CAMERA_VISIBLE_LAYERS & outline_layer_val) == outline_layer_val) {
		if (use_mask) {
			ALBEDO = texture(outline_mask, UV).rgb;
		} else {
			ALBEDO = outline_color.rgb;
		}
		#ifdef USE_ALPHA
		ALPHA = original_color.a;
		#endif
	} else {
		discard;
	}
}
