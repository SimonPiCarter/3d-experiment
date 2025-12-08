#ifdef SHADOW_ON
#else
render_mode unshaded;
#endif
#ifdef NODEPTH
render_mode depth_test_disabled;
#endif

const int mask_layer_val = 1;
const int outline_layer_val = 1<<4;
const int pickable_layer_val = 1<<5;

uniform sampler2D albedo_texture : filter_nearest, source_color;
uniform bool use_albedo_texture = false;
uniform vec4 original_color : source_color;
uniform vec4 outline_color : source_color = vec4(0.5,0.5,0.5,1.);
uniform sampler2D outline_mask : filter_nearest;
uniform bool use_mask = false;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if((int(CAMERA_VISIBLE_LAYERS) & mask_layer_val) != 0) {
		if (use_albedo_texture) {
			ALBEDO = texture(albedo_texture, UV).rgb;
		#ifdef USE_ALPHA
			ALPHA = texture(albedo_texture, UV).a;
		#endif
		} else {
			ALBEDO = original_color.rgb;
		#ifdef USE_ALPHA
			ALPHA = original_color.a;
		#endif
		}
	#ifdef SHADED
		vec3 color_orig = ALBEDO;
		vec3 normals_world = (INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz;
		const vec3 light_dir = normalize(vec3(0.902,-3.0,-5.117));
		float dot_light = dot(normals_world, light_dir);
		color_orig -= 0.2*color_orig* smoothstep(-0.5, -0.3, dot_light);
		ALBEDO = color_orig;
	#endif
	} else if((int(CAMERA_VISIBLE_LAYERS) & outline_layer_val) != 0) {
		if (use_mask) {
			ALBEDO = texture(outline_mask, UV).rgb;
		} else {
			ALBEDO = outline_color.rgb;
		}
		#ifdef USE_ALPHA
		ALPHA = original_color.a;
		#endif
	} else if((int(CAMERA_VISIBLE_LAYERS) & pickable_layer_val) != 0) {
		discard;
	}
	RIM = 0.0;
	METALLIC = 0.0;
	ROUGHNESS = 1.;
}

void light() {
	DIFFUSE_LIGHT += vec3(1.0) * ATTENUATION;
}
