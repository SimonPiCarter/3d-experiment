shader_type canvas_item;

uniform float width = 0.1;
uniform sampler2D mask;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV - vec2(0.5,0.5);
	float dist = uv.x*uv.x + uv.y*uv.y;
	float lower_ring = 0.5-width;
	float higher_ring = 0.5;
	COLOR = vec4(1,1,1,1) * step(dist, higher_ring*higher_ring) * step(lower_ring*lower_ring, dist) * texture(mask, UV);
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
