/**
 * Reinvention of Alexander Ameye's code. See https://ameye.dev/notes/rendering-outlines/
 * 
 * This shader ... TODO.
 */
shader_type spatial;

render_mode unshaded, cull_front;
/*
Constants
*/
const float DELTA = 0.0001;
/*
Uniforms
*/
uniform int extrusion_direction : hint_enum("Vertex Position", "Normal", "Custom-Authored Normal") = 1;
uniform int extrusion_space : hint_enum("Local Space", "Clip Space", "Better Clip Space") = 1;
uniform bool z_scale = true;
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
/**
 * This is a documentation comment.
 * These lines will appear in the inspector when hovering the shader parameter named "Something".
 * You can use [b]BBCode[/b] [i]formatting[/i] in the comment.
 */
uniform float outline_width : hint_range(0, 64) = 4.0;

void extrude_in_local_space(
		in vec3 direction,
		in vec3 local_position,
		in mat4 modelview,
		in mat4 projection,
		inout vec4 clip_position_reference) {
	vec3 offset = direction * outline_width;
	vec4 clip_position = projection * (modelview * vec4(local_position + offset, 1.0));
	clip_position_reference = clip_position;
}

void extrude_in_clip_space(
		in vec3 direction,
		in vec3 local_position,
		in mat4 modelview,
		in mat4 projection,
		in vec2 viewport_size,
		inout vec4 clip_position_reference) {
	vec4 clip_position = projection * (modelview * vec4(local_position, 1.0));
	vec3 clip_normal = mat3(projection) * (mat3(modelview) * direction);
	
	vec2 offset = normalize(clip_normal.xy) / viewport_size * outline_width * 2.0; 
	clip_position.xy += offset * (z_scale ? clip_position.w : 1.0);
	
	clip_position_reference = clip_position;
}

void extrude_in_better_clip_space(
		in vec3 direction,
		in vec3 local_position,
		in mat4 modelview,
		in mat4 projection,
		in vec2 viewport_size,
		inout vec4 clip_position_reference) {
	vec4 clip_position = projection * (modelview * vec4(local_position, 1.0));
	vec3 clip_normal = mat3(projection) * (mat3(modelview) * direction);
	
	float a = viewport_size.x / viewport_size.y;
	clip_normal.x = clip_normal.x * a;
	clip_normal = normalize(clip_normal);
	clip_normal.x = clip_normal.x / a;
	clip_position.xy += clip_normal.xy * outline_width * 6.0 / length(viewport_size);
	
	clip_position_reference = clip_position;
}

void vertex() {
	vec3 direction;
	
	switch(extrusion_direction) {
		case 0:
			// Move along normalized vertex position in local space
			direction = normalize(VERTEX);
			break;
		case 1:
			// Move along normal vector in local space
			direction = normalize(NORMAL);
			break;
		case 2:
			// Move along (smooth) normal vector in local space
			direction = normalize(CUSTOM0.xyz);
			break;
	}
	
	switch(extrusion_space) {
		case 0:
			extrude_in_local_space(direction, VERTEX, MODELVIEW_MATRIX, PROJECTION_MATRIX, POSITION);
			break;
		case 1:
			extrude_in_clip_space(direction, VERTEX, MODELVIEW_MATRIX, PROJECTION_MATRIX, VIEWPORT_SIZE, POSITION);
			break;
		case 2:
			extrude_in_better_clip_space(direction, VERTEX, MODELVIEW_MATRIX, PROJECTION_MATRIX, VIEWPORT_SIZE, POSITION);
			break;
	}
}

void fragment() {
	ALBEDO = outline_color.rgb;
}
