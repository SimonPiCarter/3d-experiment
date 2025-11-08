shader_type spatial;

#define NO_CULLING

uniform sampler2D Noise : source_color;
uniform float Threshold : hint_range(0.0, 1.0) = 0.5;
uniform float ThresholdAlpha : hint_range(0.0, 1.0) = 0.0;
uniform vec4 ColorHigh : source_color = vec4(0.2, 1.0, 0.2, 0.5);
uniform vec4 ColorLow : source_color = vec4(0.2, 1.0, 0.2, 0.5);

#include "sphere_vfx.gdshaderinc"
