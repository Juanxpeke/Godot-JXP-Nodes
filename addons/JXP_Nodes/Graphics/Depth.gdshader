#pragma disable_preprocessor
/**
 * For Godot 4.1 and 4.2:
 *   - Clip space Z axis goes from 0.0 to 1.0 (Vulkan / Forward+)
 *   - Clip space Z axis goes from -1.0 to 1.0 (OpenGL / Mobile, Compatibility)
 *   - Depth value is ~0.0 for closer objects, and ~1.0 for far away objects
 * For Godot 4.3+:
 *   - Clip space Z axis goes from 1.0 to 0.0 (Vulkan / Forward+)
 *   - Depth value is ~1.0 for closer objects, and ~0.0 for far away objects
 */
shader_type spatial;

render_mode unshaded;

uniform sampler2D depth_texture : hint_depth_texture;

void fragment() {
	// near (1)                                      far (0)
	// |---------------------------------------------|
	float depth = texture(depth_texture, SCREEN_UV).r;

	vec4 ndc = vec4(SCREEN_UV * 2.0 - 1.0, depth, 1.0);
	vec4 view = INV_PROJECTION_MATRIX * ndc;
	view.z /= view.w;

	ALBEDO = vec3(pow(depth, 1));
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
