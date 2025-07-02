#pragma disable_preprocessor
/**
 * Reinvention of Alexander Ameye's code. See https://ameye.dev/notes/rendering-outlines/
 *
 * This shader computes an angle factor based on the angle between the pixel's normal and the view
 * direction (from the camera to the pixel). When this angle is close to 0, the normal is facing the
 * camera directly, so the angle factor is near 0. As the angle approaches 90 degrees or more, the
 * normal becomes perpendicular to the view direction, and the angle factor approaches 1.
 *
 * As Alexander's mentions in his article, this shader only works correctly on extremely smooth
 * objects, such as a sphere.
 */
shader_type spatial;

render_mode unshaded;
// Constants
const float DELTA = 0.0001f;
// Uniforms
/**
 * Color of the outline. Alpha channel is not used.
 */
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
/**
 * Width of the outline. Determines the proportion of the object to be outlined, based on pixel normals and the view direction.
 */
uniform float outline_width : hint_range(0, 1) = 0.25f;
/**
 * Softness of the outline. Determines how much the outline opacity will be decreased.
 */
uniform float outline_softness : hint_range(0, 1) = 0.0f;
/**
 * TODO.
 */
uniform float outline_power = 1.0f;

void fragment() {
	// 0.0 if both vectors are equal, 1.0 if they're separated by a 90+ angle
	float angle_factor = 1.0 - clamp(dot(normalize(NORMAL), VIEW), 0.0, 1.0);
	// Non-linear distribution towards smaller values for any power greater than 1.0
	angle_factor = pow(angle_factor, outline_power);

	// The outline will be visible if outline_treshold <= angle_factor
	float outline_treshold = 1.0f - outline_width;
	// The outline will be fully opaque if opaque_outline_treshold <= angle_factor
	float opaque_outline_treshold = outline_treshold + outline_softness + DELTA;
	// If outline_treshold < angle_factor < opaque_outline_treshold, then the alpha channel value is interpolated
	float intensity = smoothstep(outline_treshold, opaque_outline_treshold, angle_factor);

	// We don't need to handle cases in which outline_width is greater than 1.0
	// float intensity = mix(1, smoothstep(outline_treshold, opaque_outline_treshold, angle_factor), step(0, outline_treshold));

	ALBEDO = outline_color.rgb;
	ALPHA = intensity;
}
