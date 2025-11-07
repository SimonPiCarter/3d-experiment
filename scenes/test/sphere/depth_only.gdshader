shader_type spatial;
render_mode blend_mix,depth_draw_always,cull_back,diffuse_burley,specular_schlick_ggx,unshaded;
const uint mask_layer_val = 2u; // Bitmask must match the cull mask used for MaskCamera.

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	DEPTH = 1.0;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
