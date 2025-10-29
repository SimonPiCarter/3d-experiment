shader_type spatial;

// 0.0 → 1.0
uniform float prgoress : hint_range(0.0, 1.0) = 0.5;
uniform float width : hint_range(0.0, 1.0) = 0.5;
// Tint applied to the filled (consumed) region
uniform vec4 overlay_color : source_color = vec4(0.2, 1.0, 0.2, 0.5);
// Fill direction: (1,0)=L→R, (-1,0)=R→L, (0,1)=T→B, (0,-1)=B→T, (1,1)=diag, etc.
uniform vec2 fill_dir = vec2(1.0, 0.0);
// Alpha threshold to treat as transparent (mask out)
uniform float alpha_cutoff : hint_range(0.0, 1.0) = 0.01;

uniform sampler2D albedo_texture : source_color;
uniform sampler2D noise_texture : source_color, filter_nearest, repeat_enable;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    vec4 tex = texture(albedo_texture, UV);
	vec4 noise_tex = texture(noise_texture, UV);
    if (tex.a <= alpha_cutoff) {
        discard; // ignore transparent pixels
    }

    // Safe, normalized direction (fallback to +X if near zero)
    vec2 dir = fill_dir;
    float len_dir = length(dir);
    dir = (len_dir < 1e-5) ? vec2(1.0, 0.0) : dir / len_dir;

    // Compute min/max projection of the UV quad [0,1]^2 along 'dir'
    vec2 min_corner = vec2(dir.x > 0.0 ? 0.0 : 1.0, dir.y > 0.0 ? 0.0 : 1.0);
    vec2 max_corner = vec2(1.0 - min_corner.x, 1.0 - min_corner.y);

    float min_proj = dot(min_corner, dir);
    float max_proj = dot(max_corner, dir);

    // Current pixel's normalized coordinate along the fill axis → [0,1]
    float p = dot(UV, dir);
    float pt = dot(UV, vec2(0.0, 1.0));
    float t = clamp((p - min_proj) / max(1e-6, (max_proj - min_proj)), 0.0, 1.0);

	float dt = prgoress - t;
	float dtt = abs(pt - 0.5);
    // Fill if within progress
    if (t <= prgoress+width && t >= prgoress) {
        ALBEDO = mix(tex, overlay_color, overlay_color.a).rgb;
    } else if(dt >= 0.) {
		ALBEDO = overlay_color.rgb * (1. - step(0.5, noise_tex.r + 2.*dt + dtt/2.));
	}
	else {
		ALBEDO = vec3(0,0,1);
        //ALBEDO = noise_tex.rgb;
    }
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
