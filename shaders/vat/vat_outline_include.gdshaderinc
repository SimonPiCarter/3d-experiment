
render_mode unshaded;

//depth_draw_opaque

uniform sampler2D offset_map : filter_nearest;
uniform sampler2D normal_map : filter_nearest;
uniform sampler2D texture_albedo : source_color, filter_nearest;

uniform float fps = 24.0; // change this to what the fps is in Blender

const int mask_layer_val = 1;
const int outline_layer_val = 1<<4;
const int pickable_layer_val = 1<<5;

uniform vec4 outline_color : source_color = vec4(0.5,0.5,0.5,1.);
uniform sampler2D outline_mask : filter_nearest;
uniform bool use_mask = false;
uniform sampler2D shaded_mask : filter_nearest;

#ifndef MULTIMESH
	uniform float start_frame;
	uniform float end_frame;
	uniform float anim_offset;
#endif

void vertex(){
	#ifdef MULTIMESH
		float start_frame = INSTANCE_CUSTOM.g;
		float end_frame = INSTANCE_CUSTOM.b;
		float anim_offset = INSTANCE_CUSTOM.r;
	#endif

	// frame
	float num_frames = end_frame - start_frame;
	int frame_count = int(end_frame - start_frame);

	// time
	float time_scale_normalized = fps / num_frames;
	float time = mod(TIME * time_scale_normalized, 1.0);

	float frame_offset = num_frames * anim_offset;
	float current_frame = start_frame + mod((time * num_frames) + frame_offset, num_frames);

	ivec2 tex_size = textureSize(offset_map, 0);

	float pixel_size = 1.0 / float(tex_size.y);
	float frame_floor = clamp(floor(current_frame), start_frame, end_frame);

	// New from AJ213
	//float frame_ceil = clamp(ceil(current_frame), start_frame, end_frame); // Old
	float frame_ceil = float(int(ceil(current_frame) - start_frame) % frame_count) + start_frame; // accounting for looping

	vec2 frame_floor_uv_offset = vec2(0.0, -((frame_floor + 0.5) * pixel_size));
	vec2 frame_ceil_uv_offset = vec2(0.0, -((frame_ceil + 0.5) * pixel_size));

	float lerp_factor = current_frame - frame_floor;

	vec3 offset_floor = texture(offset_map, UV2 + frame_floor_uv_offset).xyz;
	vec3 offset_ceil = texture(offset_map, UV2 + frame_ceil_uv_offset).xyz;
	vec3 offset_lerp = mix(offset_floor, offset_ceil, lerp_factor);
	vec3 new_offset = vec3(offset_lerp.x, offset_lerp.z, offset_lerp.y);

	VERTEX += new_offset;

	vec3 normal_floor = texture(normal_map, UV2 + frame_floor_uv_offset).xyz;
	vec3 normal_ceil = texture(normal_map, UV2 + frame_ceil_uv_offset).xyz;
	vec3 normal_lerp = mix(normal_floor, normal_ceil, lerp_factor);
	vec3 new_normal = vec3((normal_lerp.x * 2.0) - 1.0, (normal_lerp.z * 2.0) - 1.0, (normal_lerp.y * 2.0) - 1.0);

	NORMAL = new_normal;
}

void fragment(){
	if((int(CAMERA_VISIBLE_LAYERS) & mask_layer_val) != 0) {
		ALBEDO = texture(texture_albedo, UV).rgb;
		#ifdef USE_ALPHA
			ALPHA = texture(texture_albedo, UV).a;
		#endif
		float shaded = step(0.1, texture(shaded_mask, UV).r);

		vec3 color_orig = ALBEDO;
		vec3 normals_world = (INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz;
		float dot_light = dot(normals_world, vec3(0,-1,-1)/sqrt(2.));
		color_orig -= 0.2*color_orig* smoothstep(-0.1,0., dot_light) * shaded;
		ALBEDO = color_orig;
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
}

void light() {
	// DIFFUSE_LIGHT = ALBEDO;
	//DIFFUSE_LIGHT += ALBEDO * (1.-shaded);
	//DIFFUSE_LIGHT += LIGHT_COLOR * ATTENUATION * clamp(smoothstep(0.1, 0.15, dot(LIGHT, NORMAL)), 0, 0.5) * shaded;
}
