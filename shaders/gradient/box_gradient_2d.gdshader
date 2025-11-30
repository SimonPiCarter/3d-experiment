shader_type canvas_item;

uniform vec4 outline_color : source_color;
uniform float outline_width = 1.;
uniform vec4 gradient_color : source_color;
uniform float gradient = 10.;
uniform float min_alpha = 0.2;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 region = REGION_RECT;
	vec2 uv = UV;
	float dist = min(uv.x, min(uv.y, min(region.z-uv.x, region.w-uv.y)));
	COLOR = outline_color * step(dist, outline_width) + gradient_color * (1.-step(dist, outline_width));
	COLOR.a = outline_color.a * step(dist, outline_width) + (1.-smoothstep(0., gradient, dist)) * gradient_color.a;
	COLOR.a = max(min_alpha, COLOR.a);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
