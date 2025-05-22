/*
Reinvention of Alexander Ameye's code, see https://ameye.dev/notes/rendering-outlines/
*/
shader_type spatial;

render_mode unshaded, cull_front;
/*
Constants
*/
const float DELTA = 0.0001f;
/*
Uniforms
*/
uniform vec4 outline_color : source_color = vec4(1.0);
uniform float outline_width : hint_range(0, 1) = 0.25f;
uniform float outline_softness : hint_range(0, 1) = 0.0f;
uniform float outline_power = 1.0f;

void fragment() {
	// 1.0 if both vectors are equal, 0.0 if they're separated by a 90+ angle
	float angle_factor = clamp(dot(normalize(NORMAL), VIEW), 0.0, 1.0);
	// Now the value is 0.0 if both vectors are equal, 1.0 if they're separated by a 90+ angle 
	angle_factor = 1.0 - angle_factor;
	// Non-linear distribution towards smaller values
	angle_factor = pow(angle_factor, outline_power);
	
	// The outline will be visible if outline_treshold <= angle_factor
	float outline_treshold = 1.0f - outline_width;
	// The outline will be fully opaque if opaque_outline_treshold <= angle_factor
	float opaque_outline_treshold = outline_treshold + outline_softness + DELTA;
	// We make sure that if outline_treshold < angle_factor < opaque_outline_treshold, then there is an interpolation
	float intensity = smoothstep(outline_treshold, opaque_outline_treshold, angle_factor);
	
	/*
	We don't need to handle cases in which outline_width is greater than 1.0
	float intensity = mix(1, smoothstep(outline_treshold, opaque_outline_treshold, angle_factor), step(0, outline_treshold));
	*/
	ALBEDO = outline_color.rgb;
	ALPHA = intensity;
}
