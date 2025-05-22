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
uniform int extrusion_mode : hint_enum("Vertex Position", "Normal", "Custom-Authored Normal") = 1;
uniform int extrusion_space : hint_enum("Local Space", "Clip Space") = 1;
uniform vec4 outline_color : source_color = vec4(1.0);
uniform float outline_width : hint_range(0, 128) = 0.2f;

void vertex() {
	vec3 extrusion_direction;
	switch(extrusion_mode) {
		case 0:
			// Move vertex along normalized vertex position in local space
			extrusion_direction = normalize(VERTEX);
			break;
		case 1:
			// Move vertex along normal vector in local space
			extrusion_direction = normalize(NORMAL);
			break;
		case 2:
			// Move vertex along (smooth) normal vector in local space
			extrusion_direction = normalize(CUSTOM0.xyz);
			break;
		default:
			break;
	}
	switch(extrusion_space) {
		case 0:
			VERTEX += extrusion_direction * outline_width;
			vec4 clip_position = PROJECTION_MATRIX * (MODELVIEW_MATRIX * vec4(VERTEX, 1.0));
			POSITION = clip_position;
			break;
		case 1:
			vec4 clip_position = PROJECTION_MATRIX * (MODELVIEW_MATRIX * vec4(VERTEX, 1.0));
			vec3 clip_normal = mat3(PROJECTION_MATRIX) * (mat3(MODELVIEW_MATRIX) * extrusion_direction);
			vec2 offset = (normalize(clip_normal.xy) / VIEWPORT_SIZE) * outline_width * clip_position.w * 2.0;
			clip_position.xy += offset;
			POSITION = clip_position;
			break;
		default:
			break;
	}
}

void fragment() {
	ALBEDO = outline_color.rgb;
}
