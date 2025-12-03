shader_type spatial;
render_mode unshaded;

uniform vec4 color : source_color;
uniform sampler2D elevation;
uniform float factor = 1.;

void vertex() {
	VERTEX.y += texture(elevation, UV).r * factor;
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = color.rgb;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
