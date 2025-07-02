#pragma disable_preprocessor
/**
 * Reinvention of withoutfail's code. See https://godotshaders.com/shader/depth-based-outline-shader/
 *
 * This shader ...
 */
shader_type spatial;

render_mode unshaded, fog_disabled;

// Constants
const float DELTA = 0.0001f;
/*
Uniforms
*/
uniform sampler2D screen_texture : source_color, hint_screen_texture;
uniform sampler2D depth_texture : hint_depth_texture, repeat_disable;
uniform float sensitivity: hint_range(0.0, 3.0, 0.01);
uniform float outline_thickness: hint_range(0.0, 2.0, 0.01);
uniform float step_threshold: hint_range(0.0, 1.0, 0.01);
uniform vec3 outline_color: source_color;

float get_depth(in vec2 uv, in mat4 inverse_projection) {
	float depth = texture(depth_texture, uv).r;
	return 1.0 / (depth * inverse_projection[2].w + inverse_projection[3].w);
}

void fragment() {
	float thickness = outline_thickness * 0.008;
	float depth = get_depth(SCREEN_UV, INV_PROJECTION_MATRIX);

	// Check the depth in the four cardinal and four diagonal directions to determine whether the
	// current pixel is on an edge
	float border_r  = get_depth(SCREEN_UV + vec2( thickness,          0), INV_PROJECTION_MATRIX) - depth;
	float border_l  = get_depth(SCREEN_UV + vec2(-thickness,          0), INV_PROJECTION_MATRIX) - depth;
	float border_t  = get_depth(SCREEN_UV + vec2(         0,  thickness), INV_PROJECTION_MATRIX) - depth;
	float border_b  = get_depth(SCREEN_UV + vec2(         0, -thickness), INV_PROJECTION_MATRIX) - depth;
	float border_rt = get_depth(SCREEN_UV + vec2( thickness,  thickness), INV_PROJECTION_MATRIX) - depth;
	float border_rb = get_depth(SCREEN_UV + vec2( thickness, -thickness), INV_PROJECTION_MATRIX) - depth;
	float border_lt = get_depth(SCREEN_UV + vec2(-thickness,  thickness), INV_PROJECTION_MATRIX) - depth;
	float border_lb = get_depth(SCREEN_UV + vec2(-thickness, -thickness), INV_PROJECTION_MATRIX) - depth;

	float outline = clamp(((border_r + border_l + border_t + border_b + border_rt + border_rb + border_lt + border_lb) * sensitivity) / 8.0 , 0.0, 1.0);
	outline = smoothstep(0, step_threshold, outline);

	ALBEDO = outline * outline_color;
	ALPHA = outline;
}
