shader_type spatial;

uniform vec4 color : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = color.rgb;
	// Called for every pixel the material is visible on.
}


void light() {
	DIFFUSE_LIGHT += LIGHT_COLOR * clamp(smoothstep(0.1, 0.15, dot(LIGHT, NORMAL)), 0, 0.5);
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
}
