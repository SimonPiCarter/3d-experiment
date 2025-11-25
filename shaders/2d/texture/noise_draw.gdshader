shader_type canvas_item;

uniform sampler2D mask;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR.rgb = mix(COLOR.rgb, COLOR.rgb*0.98, vec3(1,1,1)*step(0.5, texture(mask,UV).r));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
